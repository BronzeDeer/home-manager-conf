{pkgs,lib,...}:
{
  extractRecipient = filePath:
    lib.lists.concatMap ( l :
      let
        matches= builtins.match "#[[:space:]]+Recipient:[[:space:]]+([^[:space:]]+)[[:space]]*" l;
      in 
        if matches == null then
          []
        else
          matches
    ) builtins.readFile filePath;

  processMasterIdentityFile = filePath: (
    
  );


}
