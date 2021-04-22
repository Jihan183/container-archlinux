## For contributors

- Add descriptions for all packages
- Verify the args passed to `autogen.sh` are correct for each package
- Make this container installable on an arch-based system (and others too?)
    - The `app` folder contains the scripts one will need to create the image.
    Therefore if these can be packaged for different distributions, people will be able to install this repo as a package and use the scripts found there to build the image
- Create a graphical interface for this tool so that end-users don't have to worry about running scripts
- <s>Ensure all args have a default either through the `.env` file or in the Dockerfile</s>
- The command to install packages `runuser -- "${PACMAN}"` is used a lot, can we make a function in common.sh that wraps this call?
- Slim down this fat boy. The image is quite large. Can we shrink it down to 2GB atleast? 1GB or less would be ideal.
