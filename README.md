MassEdit
========

Mass edit records in Salesforce

Current:
Gets list of all objects
Gets list of fields
Remove fields that have been added
Displays field in table with corresponding type
Add ability to only update specific items in bulk (IE run query and update those items at once)
Executes update


To Do:
Error Checking
Make UI more intuitive - Currently confusing for order things get done
Clean up code


Select Object to edit. Select Fields to edit. Run query in text field labeled WHERE if
you do not want it to run on ALL records for that object. If filter is run you will
be able to see the values to be edited and select if you want to remove some.
Filter can be on fields that are not being edited (they will not appear in the table).

This provides no checks for values so use at your own risk.
