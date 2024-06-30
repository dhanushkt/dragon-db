<?php
require '../mkvrename_creds.php';

// Connect to the remote server
$connection = ssh2_connect($creds_host, $creds_port);

if (!$connection) {
    die('Failed to connect to the remote server.');
}

// Authenticate
if (!ssh2_auth_password($connection, $creds_username, $creds_password)) {
    die('Failed to authenticate with the remote server.');
}

echo "Connected to the remote server. \n";

// Construct Command
$command = "$creds_remote_sync_scriptPath '$creds_remote_sync_url' '$creds_remote_sync_filePath'";
echo "Sending Command: $command \n";

// Execute the remote script
$stream = ssh2_exec($connection, "$command");

if (!$stream) {
    die('Failed to execute the script on the remote server.');
}

// Enable blocking for the stream
stream_set_blocking($stream, true);

// Get the output
$output = stream_get_contents($stream);

if ($output === false) {
    echo "Failed to get the output from the remote server.";
} else {
    echo "Remote script output:\n";
    echo $output;
}

// Close the stream
fclose($stream);