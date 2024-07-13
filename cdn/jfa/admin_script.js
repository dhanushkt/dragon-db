// Custom Scripts for JFA-GO admin.html
// script tag included in /opt/jfa-go/data/html/admin.html
// <script type="text/javascript" src="https://raw.githubusercontent.com/dhanushkt/dragon-db/main/cdn/jfa/admin_script.js"></script>

// Adding dynamic ID to div and updating class based on window size
document.addEventListener('DOMContentLoaded', function() {
    // Select the parent container
    var container = document.getElementById('create-inv');
    
    // Select all divs within the container
    var divs = container.getElementsByTagName('div');
    
    // Check if there is a second div
    if (divs.length > 1) {
        // Add an ID to the second div
        divs[1].id = 'create-inv-custom-id';
    }

    // Function to update class based on window size
    function updateClass() {
        if (divs.length > 1) {
            if (window.innerWidth >= 768) {
                divs[1].classList.add('w-1/2');
            } else {
                divs[1].classList.remove('w-1/2');
            }
        }
    }

    // Run the function on initial load
    updateClass();

    console.log('Custom Script Loaded');

    // Run the function on window resize
    window.addEventListener('resize', updateClass);
});