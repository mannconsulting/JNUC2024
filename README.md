# Welcome
This repository includes all the workflows that we presented during our session "Flawless MDM Communication" at the Jamf Nation User Conference 2024.

## Check-in Failure
The Jamf built in Last Check-in field is one of the few ways do identify if a computer is active. If the jamf binary or LaunchDaemon is removed or tampered with Last Check-in will no longer update making it seem as if the device is offline. Leveraging a blank configuration profile we're able to test if a computer that is supposedly offline is still receiving MDM commands. If we detect the configuration profile actually installs we can use the Jamf Pro API to push a management framework refresh to the device to re-install and repair the jamf binary and LaunchDaemon.

To automate repairing use the script `Check-in Failure API Fix.sh` which will redeploy the Jamf management framework for all eligible computers.

## Last Full Check-in
The Jamf built in Last Check-in field shows the time when the last check-in process started but doesn't indicate if it finished. This workflow validates the last time a computer not only checked in but also completed all policies scoped to it. This allows you to validate if there are issues with some policies or the check-in process in general.

## Last Full Inventory
The Jamf built in Last Inventory Update show the time when the inventory was last changed for a computer, which can be triggered by administrator changes in UI or via API. There have historically also been Jamf Product Issues that resulted in computer inventory (recon) not being written to the database properly. The Last inventory update field This workflow validates the last time a computer successfully wrote to its inventory.

## Verify APNs
Jamf doesn't provide any built in indicators the sure that computers are properly communicating using their MDM spec which runs over APNs. This is usually indicated by computers that have a number of pending or failed command, are missing configuration profiles or won't perform actions like remote wipe or lock.

# Installing Workflows
There are two options to install the workflows:

## Automatic Installers
Each workflow includes an installer that you can leverage to automatically install each workflow in your Jamf instance. To install follow these steps:
1. Clone this repository locally
2. Open Terminal and run the Installer you would like
3. Enter your full Jamf Pro URL (including https://), Jamf admin username and password.

Note: These installers are install only, it will not update if there is already groups with the same name.  If you see any errors like `<p>Error: Duplicate name</p>` then there is already an object with that name uploaded.

## Manual Installation
If you'd like to manually install the workflows please reference the included png screenshots of what each object looks like.  Remember to create objects in the following order: categories, computer extension attributes, smart groups, then policies.

Scripts for computer extension attributes are includes in the same folder with a .sh extension.

# More
This is a small sampling of our full workflows suite. If you'd like a demo of our Compliance Report and a full list of workflows we automate please come see us at https://mann.com/jamf

## Help
We provide support for these and other workflows for our customers, if you'd like assistance please consider a demo of our full Mann Jamf Workflows suite by visiting https://mann.com/jamf.
