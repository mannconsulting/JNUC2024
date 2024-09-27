# Welcome
This repository includes all the workflows that we presented during our session "Flawless MDM Communication" at the Jamf Nation User Conference 2024.

# Automatic Installers
Each workflow includes an installer that you can leverage to automatically install each workflow in your Jamf instance. To install follow these steps:
1. Clone this repository locally
2. Open Terminal and run the Installer you would like
3. Enter your full Jamf Pro URL (including https://), Jamf admin username and password.

Note: These installers are install only, it will not update if there is already groups with the same name.  If you see any errors like `<p>Error: Duplicate name</p>` then there is already an object with that name uploaded.

# Manual Installation
If you'd like to manually install the workflows please reference the included png screenshots of what each object looks like.  Remember to create objects in the following order: categories, computer extension attributes, smart groups, then policies.

Scripts for computer extension attributes are includes in the same folder with a .sh extension.

# More
This is a small sampling of our full workflows suite. If you'd like a demo of our Compliance Report and a full list of workflows we automate please come see us at https://mann.com/jamf

# Help
We provide support for our workflows customers, if you'd like assistance 
