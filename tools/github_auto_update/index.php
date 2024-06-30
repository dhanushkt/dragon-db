<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sync MKVRN API Code</title>
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-color: #f0f0f0;
        }

        button {
            padding: 10px 20px;
            margin: 10px;
            border: none;
            border-radius: 5px;
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        #output {
            margin-top: 20px;
            width: 80%;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        pre {
            font-family: 'Fira Code', monospace;
            /* Use 'monospace' as a fallback */
            font-size: 16px;
            /* Adjust the font size as needed */
            background-color: #f5f5f5;
            /* Light background for better readability */
            color: #333;
            /* Text color */
            padding: 10px;
            /* Space inside the pre tag */
            border-radius: 4px;
            /* Rounded corners for aesthetics */
            overflow: auto;
            /* Scroll if content overflows */
            white-space: pre-wrap;
            /* Preserve whitespace and wrap text */
        }
    </style>
</head>

<body>
    <button id="syncLocalButton">Sync MKVRN PHP Code (Local)</button>
    <button id="syncRemoteButton">Sync MKVRN Scripts (Remote)</button>
    <pre id="output"></pre>

    <script>
        function displayOutput(data) {
            document.getElementById('output').textContent = data;
        }

        document.getElementById('syncLocalButton').addEventListener('click', function () {
            fetch('sync_local.php')
                .then(response => response.text())
                .then(data => displayOutput(data))
                .catch(error => displayOutput('Error: ' + error));
        });

        document.getElementById('syncRemoteButton').addEventListener('click', function () {
            fetch('sync_remote.php')
                .then(response => response.text())
                .then(data => displayOutput(data))
                .catch(error => displayOutput('Error: ' + error));
        });
    </script>
</body>

</html>