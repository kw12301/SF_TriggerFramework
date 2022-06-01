OrganizationObjectTree tree = OrganizationObjectTree.getTree();
System.debug(
	'Standard Objects: ' + tree.standardObjects.size() + '\n' +
    'Custom Objects: ' + tree.customObjects.size() + '\n' +
    'Named Objects: ' + tree.standardObjects.size() + '\n' +
    'Custom Settings: ' + tree.customSettings.size() + '\n' +
    'Named Settings: ' + tree.namespacedCustomSettings.size()
);