# Changelog

## [0.43.2] - 2019-05-19

Added

- Privacy policies

## [0.43.1] - 2019-05-18

Changed

- Set iOS global platform

## [0.43.0] - 2019-05-18

Added

- Bottom padding for details dialog

Removed

- Unused fonts

## [0.42.0] - 2019-05-16

Added

- Custom color on splash screen

Changed

- Fixed weird color issue on Android app icon

## [0.41.1] - 2019-05-16

Changed

- Convert to AndroidX and get it runnable once again

## [0.41.0] - 2019-04-28

Added

- Firebase analytics for iOS

Changed

- Extend front layer of Backdrop over the bottom SafeArea

## [0.40.0] - 2019-04-27

Added

- Firebase analytics for Android

## [0.39.1] - 2019-04-26

Removed

- Quiver dependency as never used the overridden hashCode for Options

## [0.39.0] - 2019-04-26

Added

- Page indices of results

Removed

- Dot page indicators

## [0.38.0] - 2019-04-26

Added

- Page tooltip to dot page indicators

Changed

- Lowered anagram upper length bound to 45
  - Sadly excluding Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch
  - But probably best for usability of the length slider
- Bumped version of range slider for some fixes
  - Including error when sliding two thumbs together

## [0.37.1] - 2019-04-19

Changed

- Fixed the result counter label
- Size of page indicator dots

## [0.37.0] - 2019-04-19

Added

- A cleaned up version of a paginated anagram list (dot indicators do not scroll as I want yet)

Changed

- Cleaned up the anagram list widget structure
- Renamed `app_flow` to `view` because it is way less weird
- Separated out `dots_indicator` into its own file

## [0.36.0] - 2019-04-16

Added

- A messy version of a paginated anagram list. Need to clean up the results label at least

## [0.35.2] - 2019-04-15

Changed

- Don't resize the home widget to avoid showing background color when opening keyboard

## [0.35.1] - 2019-04-02

Changed

- Input border color to match text color

## [0.35.0] - 2019-03-31

Added

- iOS launch icons (tentative)

Changed

- Theme colors (lightened red)

## [0.34.1] - 2019-03-30

Changed

- Theme colors (darkened red and lightened yellow)

Removed

- Overscroll on input page

## [0.34.0] - 2019-03-30

Added

- In progress Android launch icon
- Anagrammatic logo in app bar

Changed

- Font to RobotoCondensed
- Center title in app bar
- Colors to match Anagrammatic branding

## [0.33.1] - 2019-03-19

Changed

- Only update options if altered
- Update range slider library
- Included identifier in option classes for easy storage

## [0.33.0] - 2019-02-25

Changed

- New range slider library for length restrictions
- Added padding to detail expansion panels to prevent bug of going outside container
- Cleaned up pubspec

## [0.32.0] - 2019-02-25

Added

- Help text on input screen

Changed

- Rounded corners of details dialog

## [0.31.0] - 2019-02-18

Added

- Wildcard character (*) for input
- Set overlay color (to correct the toolbar icon color on ios)

Changed

- Spacing on "no results" screen

## [0.30.0] - 2019-02-16

Added

- Save word list choice to preferences storage

Changed

- Back button in details dialog switched to OutlineButton

## [0.29.1] - 2019-02-16

Changed

- Vertically spaced out the action buttons in the detail dialog

## [0.29.0] - 2019-01-08

Added

- Truncate results to a fixed number
- Dialog details page

Changed

- Display names of sort types
- Default to reverse length sort type

## [0.28.0] - 2019-01-03

Changed

- Separated out the length range slider for two individual sliders
  until either the range slider is fully functional or a better
  alternative is available
- Altered the "No results" text

Removed

- Huge text scaling (made things unusable in other capacities when used)

## [0.27.1] - 2019-01-02

Removed

- Value indicator on length slider

## [0.27.0] - 2019-01-01

Added

- Result count

Changed

- Some work on spreading theme across different elements

Removed

- LICENSE file as I don't believe it is needed for using components
  from Flutter Gallery

## [0.26.2] - 2018-12-31

Changed

- Can't hit transparent back button from options menu
- Restructured files

## [0.26.1] - 2018-12-31

Changed

- Increased the maximum anagram length
- Changed the no results text

## [0.26.0] - 2018-12-31

Added

- Write display settings to shared preferences to persist across instances

## [0.25.0] - 2018-12-31

Added

- More extensive word list choices

Changed

- Moved word list choice to a dropdown as it's far more intuitive
- Started using SCOWL word lists for more consistent complexity scaling
- Made constructor-property ordering more consistent
- All double quotes to single quotes

## [0.24.2] - 2018-12-28

Changed

- Shortened word list switch label to be more concise and fit text
  with huge scaling

## [0.24.1] - 2018-12-28

Changed

- Threw padding at the bottom of the options page to enable scrolling.
  The better alternative is manipulate the backLayer height so the viewable
  area is what is shown when scrolling.

## [0.24.0] - 2018-12-28

Added

- Choice between a simple and complex word lists

## [0.23.0] - 2018-12-28

Added

- Text scaling option

Changed

- Changed dropdown classes to something logical instead of a crazed,
  enumerated mess

## [0.22.0] - 2018-12-28

Added

- Back button in app bar which was mistakenly removed

Changed

- Moved anagram length constants into own class and file to avoid
- having a messy constants file.

## [0.21.1] - 2018-12-27

Added

- Transition logic when pressing Android system back button

Changed

- Display (someday) a logo in place of back button on options page.
  This will simplify user flow by limiting navigation routes out of the
  options page.

## [0.21.0] - 2018-12-27

Added

- Result sorting based on primary and secondary comparators

Removed

- app_bar.dart as it is no longer used
- Unused transition property for Backdrop

## [0.20.1] - 2018-12-27

Added

- Display message when filtering results in 0 results

Changed

- Used ListTiles.divideTiles() to avoid implementing that logic
- Consolidated multiple paddings in the input widget

## [0.20.0] - 2018-12-26

Changed

- Immediately reverted back to the backdrop model by
  only propagating settings changes on menu exit
- Increased the length limit to the longest word within
  the current word list

## [0.19.0] - 2018-12-26

Changed

- Moved from backdrop settings to individual page in favor of
  performance over the convenience and looks

## [0.18.0] - 2018-12-25

Added

- Maximum length option
- Filter results based on length
- Constants file for global configurations

## [0.17.0] - 2018-12-22

Added

- Minimum length options

Changed

- More inherited actions for option state
- Fixed definition link functionality

Removed

- Passing around functions to alter option state

## [0.16.1] - 2018-12-22

Added

- Heading widget for options page

Changed

- Named parameters for options headings
- Formatting work

## [0.16.0] - 2018-12-21

Added

- Theme switch in options menu
- LICENSE file

Changed

- Hierarchy of widgets
- Logic to transition between pages

## [0.15.0] - 2018-12-15

Added

- Retroactively created CHANGELOG off commit messages

## [0.14.0] - 2018-12-15

Added

- Successful backdrop menu across pages

## [0.13.0] - 2018-12-12

Changed

- Broke up files

Notes

- Still unable to carry menu across pages

## [0.12.0] - 2018-12-12

Added

- Backdrop menu (struggle to unify across input and list screens)

## [0.11.0] - 2018-12-10

Added

- Generate all length anagrams

Changed

- Went from list of cards to divided text widgets

Removed

- Anagram length input

## [0.10.0] - 2018-12-02

Added

- Submit FloatingActionButton

Changed

- Capitalize app name
- Back to TextInputFormatters as a PR is out to fix ios bug

## [0.9.1] - 2018-12-02

Added

- Submit button
- Better input validation

## [0.9.0] - 2018-12-02

Changed

- Combine input screens

## [0.8.1] - 2018-12-02

Added

- Alphabetize anagram results

## [0.8.0] - 2018-12-02

Changed

- Moved from an external API to on device processing

## [0.7.2] - 2018-12-01

Removed

- New keyword for constructors as it is not needed in Dart

## [0.7.1] - 2018-11-27

Changed

- Color of splash screens
- Moved app widget into own file
- Format the text for length input

## [0.7.0] - 2018-11-25

Changed

- New input validation as TextInputFormatters are broken on ios

## [0.6.0] - 2018-11-24

Added

- Submit buttons on input screens

Changed

- Corrected name spelling
- Altered card layout

## [0.5.1] - 2018-11-24

Changed

- Reorganized widgets among files

## [0.5.0] - 2018-11-24

Changed

- Input formatting

## [0.4.0] - 2018-11-23

Added

- Display message if no results are found

## [0.3.0] - 2018-11-23

Added

- Definition capability

## [0.2.0] - 2018-11-23

Added

- Display anagrams fetched from API

## [0.1.1] - 2018-11-19

Changed

- Move null removal logic

## [0.0.1] - 2018-11-18

Added

- First working version
- Hitting API in a messy way