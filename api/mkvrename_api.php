<?php
/* 
MKVRN API
This PHP API code is designed to remotely execute the mkvrename script on a webhook call using the ssh2 extension on a remote server where the media is located. The script file (.sh) to be executed should be placed on the VM.
Triggered by Radarr/Sonarr WebHook Connection for "Import" and "Upgrade" events.
API by: Dragon DB
Version: 1.1
*/

// API Flags
$skip_anime = true;

// Create a log file to store the API logs
date_default_timezone_set('Asia/Kolkata');
$log_dir = "mkvrename_api_logs";
// Check if the directory exists, and create it if it doesn't
if (!is_dir($log_dir)) {
    mkdir($log_dir, 0777, true);
}
$log_current_date = date('d-m-Y_H-i-s');
$log_filename = $log_dir . "/mkvrename_api_log_$log_current_date.txt";
$log_file = fopen($log_filename, 'a');

/* Functions */
// Function to remove escaping backslashes
function clean_path($path)
{
    return str_replace('\\', '', $path);
}

// Function to execute the remote script using ssh2
function executeRemoteScript($host, $port, $username, $password, $scriptPath, $params)
{
    // Establish a connection to the remote host
    $connection = ssh2_connect($host, $port);
    if (!$connection) {
        return ('SSH Connection failed');
        //die('Connection failed');
    }

    // Authenticate with the remote host
    if (!ssh2_auth_password($connection, $username, $password)) {
        return ('SSH Authentication failed');
        //die('Authentication failed');
    }

    // Create the command to execute
    $command = $scriptPath . ' ' . implode(' ', array_map('escapeshellarg', $params));

    // Execute the command
    $stream = ssh2_exec($connection, $command);
    if (!$stream) {
        return ('SSH Command execution failed');
        //die('Command execution failed');
    }

    // Set stream blocking and fetch the output
    stream_set_blocking($stream, true);
    $output = stream_get_contents($stream);

    // Close the stream
    fclose($stream);

    // Return the output
    return "Sending command: \n" . $command . "\n" . "Output from Remote Script: \n" . $output;
}

// Function to check if path containes "Anime"
function containsAnime($path){
    $searchPath = '/media/Anime';
    return strpos($path, $searchPath) !== false;
}

fwrite($log_file, "====================================================== \n");
fwrite($log_file, "Triggered MKV Rename API on " . date('d-m-Y h:i:s A') . "\n");
fwrite($log_file, "====================================================== \n");


// Get the header "User Agent" from $_SERVER
if (isset($_SERVER['HTTP_USER_AGENT'])) {
    $userAgent = $_SERVER['HTTP_USER_AGENT'];
    fwrite($log_file, "User-Agent: " . $userAgent . "\n");
} else {
    fwrite($log_file, "User-Agent header is not set.\n");
}

// Get the body content from API response
$api_body = file_get_contents('php://input');
$api_body_json = json_decode($api_body, true);
fwrite($log_file, "API Body Content: " . $api_body . "\n");

// There are two possibility in api_body_json - movie or series, check and select values accordingly
$folderPath = '';
$relativePath = '';
$clean_folderPath = '';
$clean_relativePath = '';

// Check if the data structure is for a movie
if (isset($api_body_json['movie']) && isset($api_body_json['movieFile'])) {
    $folderPath = $api_body_json['movie']['folderPath'];
    $clean_folderPath = clean_path($folderPath);
    $relativePath = $api_body_json['movieFile']['relativePath'];
    $clean_relativePath = clean_path($relativePath);

    // log
    fwrite($log_file, "Radarr Folder Path: " . $folderPath . "\n");
    fwrite($log_file, "Radarr Clean Folder Path: " . $clean_folderPath . "\n");
    fwrite($log_file, "Radarr Relative Path: " . $relativePath . "\n");
    fwrite($log_file, "Radarr Clean Relative Path: " . $clean_relativePath . "\n");
}

// Check if the data structure is for a series
elseif (isset($api_body_json['series']) && isset($api_body_json['episodeFile'])) {
    $folderPath = $api_body_json['series']['path'];
    $clean_folderPath = clean_path($folderPath);
    $relativePath = $api_body_json['episodeFile']['relativePath'];
    $clean_relativePath = clean_path($relativePath);

    // log
    fwrite($log_file, "Sonarr Folder Path: " . $folderPath . "\n");
    fwrite($log_file, "Sonarr Clean Folder Path: " . $clean_folderPath . "\n");
    fwrite($log_file, "Sonarr elative Path: " . $relativePath . "\n");
    fwrite($log_file, "Sonarr Clean Relative Path: " . $clean_relativePath . "\n");
}

// Check for Anime in folderPath and skip it if skip_anime is true
if ($skip_anime && containsAnime($clean_folderPath)) {
    fwrite($log_file, "Skip Anime is enabled. Exiting \n");
    fwrite($log_file, "====================================================== \n");
    fclose($log_file);
    http_response_code(200);
    echo json_encode([
        "status" => "error",
        "message" => "Anime is Skipped."
    ]);
    exit(0);
}

// Check if clean_folderPath and clean_relativePath are not empty and if it is empty then exit the php code
if (empty($clean_folderPath) || empty($clean_relativePath)) {
    fwrite($log_file, "Folder Path or Relative Path is empty. Exiting \n");
    fwrite($log_file, "====================================================== \n");
    fclose($log_file);

    // Send HTTP 200 OK response before exiting
    http_response_code(200);
    echo json_encode([
        "status" => "error",
        "message" => "Folder Path or Relative Path is empty."
    ]);
    exit(0);
}

// Combine clean folder path and relative path
$final_path = $clean_folderPath . '/' . $clean_relativePath;
fwrite($log_file, "Final Path: " . $final_path . "\n");

// Send an SSH command to the remote server
include_once ('mkvrename_creds.php');
$ssh_output = executeRemoteScript($creds_host, $creds_port, $creds_username, $creds_password, $creds_scriptPath, [$final_path]);
fwrite($log_file, "SSH Function Output: \n" . $ssh_output . "\n");

fwrite($log_file, "End of MKV Rename API \n");
fwrite($log_file, "====================================================== \n");

fclose($log_file);