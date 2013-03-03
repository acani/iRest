# iRest

iRest is a simple OS X application that locks your screen between 8 PM & 5 AM.

## Usage

### Quit

While your screen is locked, you can only unlock it by shutting down (by holding down the power button) and then starting up.

While your screen is unlocked, you can kill iRest by entering the following command in Terminal:

    killall iRest


### Change Times

To change the screen-lock period:

1. Quit iRest.
2. Use Xcode to find & replace "8 PM" & "5 AM."
3. Product > Archive. Distribute... > Export as Application.
