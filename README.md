# CIS 452 Whack-a-Mole Project
### (My first iOS app)
This project's aim was to use concurrency to control a set of Moles that would randomly "pop up out of their holes", using either multiple threads or processes to represent each Mole.  Threads were used for this project (multiple processes seemed like overkill). A semahpore regulates how many threads (moles) can "peek" out of the ground at a time.

We were given much freedom in our design choices for this project.  We could use any platform that we wanted, as long as we could demonstrate concurrency control and create a GUI. I used this as an opportunity to try something new and learn iOS development.  The game is written in Swift and uses Apple's built in classes for threads and semaphores.  

### Details
* Single screen app that has a 4x4 grid of buttons, which represents the moles' holes.
* When the game is started, the user has 30 seconds to whack as many moles as possible.
* The user can configure how many moles can be revealed at any one time
	+ This can make the game harder by showing less moles at a time
* When the game ends (either by time running out or the user manually ending it), the number of moles whacked is reported.

### Notes
* When the game is ended, the app will hang as it waits for all threads to exit.  This is to avoid accidentally having more threads than we need currently running.
	+ If the user were to immediately start a new game after ending one, there would an overlap where the app would be running all the new threads plus the threads waiting to exit.
* The app's interface isn't exactly good-looking. (Remember this is my first try at an iOS app.)
