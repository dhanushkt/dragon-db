# Bash Scripts

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Flow](#flow)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

Scripts for automating process of analysing & changing MKV files, Radarr & Sonarr applications

## Getting Started <a name = "getting_started"></a>

### Prerequisites

Things you need to install for the scripts to run as intended.

```
mkvtoolnix
```
```
mkvinfo
```
```
mkvpropedit
```

## Usage <a name = "usage"></a>

Run the script directly
```
./mkvrename.sh
```
## Script Flow <a name = "flow"></a>

- Select Media Type (Movies, TV Shows, Anime)
    - Search for media name .mkv & add path to array
    - Select the .mkv file from the list
    - Get options to perform verious operations on selected .mkv
        - Get Info
        - View Name
        - Delete Name
        - Replace Name (BETA)
        - Exit