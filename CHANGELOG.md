# Changelog

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