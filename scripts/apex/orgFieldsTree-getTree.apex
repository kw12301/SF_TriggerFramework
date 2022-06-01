ObjectFieldTree tree = ObjectFieldTree.getTree(new Account());
System.debug('----- Standard Fields ---------');
System.debug('Count: ' + tree.standardFields.size());
System.debug('    ----- field infos -----');
for(ObjectFieldTree.StandardField sf : tree.standardFields){
    System.debug('API Name: ' + sf.apiName + '\n' +
                'Label: ' + sf.label + '\n' +
                 'Type: ' + sf.fieldType + '\n' +
                 'Encrypted: ' + sf.isEncrypted + '\n' +
                 'External Id: ' + sf.isExternalId + '\n' +
                 'Access: ' + JSON.serializePretty(sf.access));
    
}
System.debug('----- Custom Fields ---------');
System.debug('Count: ' + tree.customFields.size());
System.debug('    ----- field infos -----');
for(ObjectFieldTree.CustomField cf : tree.customFields){
    System.debug('API Name: ' + cf.apiName + '\n' +
                'Label: ' + cf.label + '\n' +
                 'Type: ' + cf.fieldType + '\n' +
                 'Encrypted: ' + cf.isEncrypted + '\n' +
                 'External Id: ' + cf.isExternalId + '\n' +
                 'Access: ' + JSON.serializePretty(cf.access));
    
}
System.debug('----- Named Fields ---------');
System.debug('Count: ' + tree.namespacedFields.size());
System.debug('    ----- field infos -----');
for(ObjectFieldTree.NamespacedField nf : tree.namespacedFields){
    System.debug('API Name: ' + nf.apiName + '\n' +
                'Label: ' + nf.label + '\n' +
                 'Type: ' + nf.fieldType + '\n' +
                 'Encrypted: ' + nf.isEncrypted + '\n' +
                 'External Id: ' + nf.isExternalId + '\n' +
                 'Namespace: ' + nf.namespace + '\n' +
                 'Access: ' + JSON.serializePretty(nf.access));
    
}

System.debug('----- Unhandled Fields ---------');
System.debug('Count: ' + tree.unhandledFields.size());
System.debug('    ----- field infos -----');
for(ObjectFieldTree.UnhandledFIeld uf : tree.unhandledFields){
    System.debug('API Name: ' + uf.apiName + '\n' +
                'Label: ' + uf.label + '\n' +
                 'Type: ' + uf.fieldType + '\n' +
                 'Encrypted: ' + uf.isEncrypted + '\n' +
                 'External Id: ' + uf.isExternalId + '\n' +
                 'Access: ' + JSON.serializePretty(uf.access));
    
}





