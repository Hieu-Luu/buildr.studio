## Story 1:

- When the users open the app, they see the Home screen.
- On the Home screen, users see a list of tool names.
- The list of tool names is a constant for demo purpose.
- By default, users see the first tool in the list is selected.
- Users can click on other tool names to switch the selected tool.
- When a tool name is selected, users see a list of variables that the tool requires.
- For demo purpose, each tool has a fix list of variables.
- On the Home screen, users also see the output text area where the output when running a tool is displayed.

## Story 2:

- When users open the app, they see the Home screen.
- On the Home screen, users see a list of tool names.
- The list of tool names is loaded from a JSON file in the asset bundle.
- The JSON file contains a list of tools, each tool has the name, the description, the id.

## Story 3:

- Addition to existing UI of the Home screen, users should see the info icon at the end of each tool item in the list.
- When users hover on the icon, it shows the tool description in the tooltip.

## Story 4:

- Addition to current features, when a tool is selected, the list of variables is loaded from a tool-specific JSON file in the asset bundle.
- The file name is the tool id.
- The JSON file contains the list of variables.
- Each variable contains these information:
  - Name
  - Description
  - Value format: plain text | JSON object
  - Input type: text field | dropdown
  - Source name (If the input type is dropdown)
  - Hint label (to show when the input value is empty)
  - Select label (to show when the input type is dropdown and the input value is empty)

## Story 5:

- Addition to current features, the Home screen should be responsive.
- When the screen width is less than the tablet width:
  - The current side bar should be hidden.
  - There should be a hamburger menu button on the top left of the screen.
  - When users click on the hamburger menu button, the tablet version of the side bar shows up by sliding from the left. It shows on top of the current UI.
  - When the tablet version side bar is opened, it has a collapse button on the top right to slide the side bar to the outside of the UI and show the hamburger menu button again.
  - While the table version side bar is opened, if the screen size is changed to be larger than the tablet width, the states must be reset and the old side bar should be shown.

## Story 6:

- Addition to current features, when the screen is large, the side bar should not show the collapse button on the top right corner.

## Story 7:

- Addition to current features, there should be a navigation rail on the left side of the app.
- The sidebar is placed on the right of the navigation rail.
- The Variable and the Output sections are placed on the right of the sidebar.
- The navigation rail is always display no matter what the screen size is.
- The navigation rails contains 2 items:
  - 1st: A build icon
  - 2nd: A file explorer icon
- The side bar should not contain the list of tool names only anymore. The side bar content should depend on the selected icon on the navigation rail as described below:
  - When the screen width is larger than 800:
    - The side bar is always shown next to the navigation rail.
    - When the build icon is selected on the rail, the side bar shows the list of tool names as how the side bar is currently implemented.
    - When the file explorer icon is selected, the side bar shows a placeholder text.
  - When the screen width is less than 800:
    - The side bar is hidden by default.
    - When an icon on the navigation rail is clicked, the side bar shows up at the front of the current UI, next to the navigation rail.
    - When the same icon is clicked again, the side bar is hidden again.
    - When another icon is clicked while the side bar is showing, the content of the side bar changes. The side bar is still showing.
- Implementation suggestions:
  - The NavigationRail class of `material` package is recommended to use.
  - The SideBar should accept a child widget that shows the content.

## Story 8:

- Addition to the current features.
- When the screen size is less than 800:
  - The side bar is hidden by default.
  - When an icon on the navigation rail is clicked, the side bar is shown next to navigation rail as the current implementation. But the side bar must be placed on the above layer that covers the variable and output sections below.
  - If the current selected icon is clicked, the side bar should disappear.
  - If an icon that is not the current selected icon is clicked while the side bar is showing, the content of the side bar changes. The side bar is still showing.
- When the screen width is larger than 800:
  - The side bar is always shown next to the navigation rail.
  - When the build icon is selected on the rail, the side bar shows the list of tool names as how the side bar is currently implemented.
  - When the file explorer icon is selected, the side bar shows a placeholder text.