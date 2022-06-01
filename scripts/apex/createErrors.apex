List<Account> newList = new List<Account>();
for(integer i = 0; i < 10; i++){
    newList.add(new Account(OwnerId = UserInfo.getUserId()));
}
GlobalDMLHandler.insertObjectList(newList);