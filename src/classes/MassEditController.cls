public class MassEditController {
/*
Mass Edit Controller

Purpose: Update all records of an object with changes based on selected fields

Current:
Gets list of all objects
Gets list of fields
Remove fields that have been added
Displays field in table with corresponding type
Add ability to only update specific items in bulk (IE run query and update those items at once)
Executes update


To Do:
Add tests
Make UI more intuitive - Currently confusing for order things get done
Clean up code

Add option for bulk update 
*/
    public String searchText {get; set;} 

    public List<SelectableObject> results {get; set;}
    public SObject stub_obj {get; set;}

    // Map os string and sobject types since it was having trouble displaying sobjecttype names
    public Map<String, String> objNames {get; set;}
    public String selectedObj {get; set;}

    // Do the same thing with fields
    public Map<String, String> fieldNames {get; set;}
    public List<String> listFieldNames {get; set;}
    public String selectedField {get; set;}
    public String removeField {get; set;}
    // Keep track of what fields need to be updated
    // Needs to be looked at (either remove it or make it a list)
    public List<String> toUpdate_fields {get; set;}

    public List<SelectableObject> filteredObjects;
    public Boolean all_selected {get; set;}


    // Initialize all the things
    public MassEditController() 
    {
        objNames = MassEditUtility.getObjectNames();
        fieldNames = new Map<String, String>();
        toUpdate_fields = new List<String>();
        listFieldNames = new List<String>();
        all_selected = true;
    }


    // Add selected field to table of fields to update 
    public PageReference addSelectedField()
    {
        toUpdate_fields.add(selectedField);
        return null;
    }

    public PageReference removeSelectedField()
    {
        toUpdate_fields = MassEditUtility.removeSelectedField(toUpdate_fields, removeField);
        return null;
    }

    // Get all the fields for the specified object
    public PageReference getFields() 
    {
        stub_obj = MassEditUtility.getObject(selectedObj);
        fieldNames = MassEditUtility.getObjectFields(selectedObj);
        for(String s : fieldNames.keySet())
            listFieldNames.add(s);
        return null;
    }

    // Place holder / test -- Right now it queries all objects based on keyset of fields
    public PageReference doSearch() 
    {
        String query = 'Select ';
        List<String> keyset = new List<String>(fieldNames.keySet());
        for(Integer i = 0; i < keyset.size();i++)
        {
            if(i != keyset.size()-1)
            {
                query += keyset[i] + ', ';
            } else {
                query += keyset[i] + ' ';
            }
        }
        query += 'FROM ' + selectedObj;
        if(searchText.length() > 1)
            query += ' WHERE ' + searchText ;
        results = new List<SelectableObject>();
        for(SObject o : Database.query(query))
            results.add(new SelectableObject(o,true));
        return null;
    }

    // Perform the update -- just queries
    public PageReference doUpdate()
    {
        if(results == null)
            updateAll();
        else
            selectiveUpdate();
        PageReference pageRef = Page.MassEditPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
    // Update only those that were selected in dropdown
    private void selectiveUpdate()
    {
        List<SObject> toUpdate = new List<SObject>();
        for(SelectableObject o : results)
            if(o.selected)
                toUpdate.add(o.o);

        for(SObject o : toUpdate)
            for(String s : toUpdate_fields)
                o.put(s,stub_obj.get(s));
        update toUpdate;        
    }

    // Update all records
    private void updateAll()
    {
        List<SObject> toUpdate = new List<SObject>();
        String query = 'SELECT id, ';
        for(Integer i = 0; i < toUpdate_fields.size(); i++)
        {
           if(i != toUpdate_fields.size()-1)
             {
                query += toUpdate_fields[i] + ', ';
            } else {
                query += toUpdate_fields[i] + ' ';
            }
        }
        query += 'FROM ' + selectedObj;
        toUpdate = Database.query(query);
        for(SObject o : toUpdate)
            for(String s : toUpdate_fields)
                o.put(s,stub_obj.get(s));
        update toUpdate;
    }

    // Sets the selected value for all our results
    public PageReference doSelectAll()
    {
        for(SelectableObject o : results)
            o.selected = all_selected;
        return null;
    }

    public class SelectableObject
    {
        public Boolean selected {get; set;}
        public SObject o {get; set;}

        public SelectableObject(SObject o, Boolean t)
        {
            this.o = o;
            this.selected = t;
        }
    }

}