<?php
// Dragon DB CI Pipeline
// Custom deployment pipeline script for deploying Dragon DB APIs and Scripts from GitHub

// Config & Cred file [optional - can provide creds in JSON file]
include_once ('path/to/config.php');

// Load the JSON file by PATH or URL
$jsonFile = 'path/to/pipeline.json';
// Check if the file exists
if (!file_exists($jsonFile)) {
    echo "File does not exist: $jsonFile";
    exit;
}

$jsonData = file_get_contents($jsonFile);
// Check if the file content was successfully read
if ($jsonData === false) {
    echo "Failed to read the file: $jsonFile";
    exit;
}

$data = json_decode($jsonData, true);
// Check if the JSON data was decoded successfully
if ($data === null && json_last_error() !== JSON_ERROR_NONE) {
    echo "Error decoding JSON: " . json_last_error_msg();
    exit;
}
// Check if the JSON data is an empty array or null
if (empty($data)) {
    echo "JSON data is empty";
    exit;
}

// Function to perform local deployment
function localDeploy($githubRawUrl, $pathWithFilename)
{
    $fileContent = file_get_contents($githubRawUrl);
    if ($fileContent === false) {
        throw new Exception("Failed to fetch file from GitHub URL: $githubRawUrl");
    }
    file_put_contents($pathWithFilename, $fileContent);
    echo "Local deployment completed. File saved to $pathWithFilename<br/>";
}

// Function to perform remote deployment
function remoteDeploy($scriptCommand, $githubUrl, $pathWithFilename, $sshHost, $sshPort, $sshUsername, $sshPassword)
{
    $connection = ssh2_connect($sshHost, $sshPort);
    if (!$connection) {
        throw new Exception("Failed to connect to SSH host: $sshHost");
    }
    if (!ssh2_auth_password($connection, $sshUsername, $sshPassword)) {
        throw new Exception("Failed to authenticate with SSH host: $sshHost");
    }

    // Build the command; if customCommand is empty, it will not be included
    $command = "$scriptCommand '$githubUrl' '$pathWithFilename'";
    echo "Sending command: $command<br/>";

    $stream = ssh2_exec($connection, $command);
    if (!$stream) {
        throw new Exception("Failed to execute command on SSH host: $sshHost");
    }

    stream_set_blocking($stream, true);
    $output = stream_get_contents($stream);
    fclose($stream);

    echo "Remote deployment output:<br/>";
    echo nl2br($output);
}

// Process local deployments from JSON
echo "=========================================================== <br/>";
echo "Starting Local Deployment Pipeline<br/>";
foreach ($data['pipeline']['local_deployments'] as $localDeployment) {
    echo "----------------------------------------------------------- <br/>";
    echo "GitHub URL: " . $localDeployment['github_raw_url'] . "<br/>";
    echo "Path & Filename: " . $localDeployment['path_with_filename'] . "<br/>";
    localDeploy($localDeployment['github_raw_url'], $localDeployment['path_with_filename']);
    echo "----------------------------------------------------------- <br/>";
}
echo "Completed Local Deployment Pipeline<br/>";
echo "=========================================================== <br/>";

// Process remote deployments
echo "=========================================================== <br/>";
echo "Starting Remote Deployment Pipeline<br/>";
foreach ($data['pipeline']['remote_deployments'] as $remoteDeployment) {
    $remoteData = $remoteDeployment;
    $sshData = $remoteData['ssh'] ?? [];  // Use empty array if 'ssh' is not provided

    $sshHost = $sshData['host'] ?? DEFAULT_CI_SSH_HOST;
    $sshPort = $sshData['port'] ?? DEFAULT_CI_SSH_PORT;
    $sshUsername = $sshData['username'] ?? DEFAULT_CI_SSH_USERNAME;
    $sshPassword = $sshData['password'] ?? DEFAULT_CI_SSH_PASSWORD;
    $scriptCommand = $remoteData['script_command'] ?? DEFAULT_CI_SCRIPT_COMMAND;

    echo "----------------------------------------------------------- <br/>";
    echo "GitHub URL: " . $remoteData['github_url'] . "<br/>";
    echo "Path & Filename: " . $remoteData['path_with_filename'] . "<br/>";
    echo empty($sshData) ? "Custom SSH creds is empty using default <br/>" : "Custom SSH creds is provided <br/>";

    remoteDeploy(
        $scriptCommand,
        $remoteData['github_url'],
        $remoteData['path_with_filename'],
        $sshHost,
        $sshPort,
        $sshUsername,
        $sshPassword
    );
    echo "----------------------------------------------------------- <br/>";
}
echo "Completed Remote Deployment Pipeline<br/>";
echo "=========================================================== <br/>";

?>