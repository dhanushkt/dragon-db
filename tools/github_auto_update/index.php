<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sync Code</title>
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
    </style>
</head>

<body>
    <button id="syncLocalButton">Sync Local Code</button>
    <button id="syncRemoteButton">Sync Remote Code</button>
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