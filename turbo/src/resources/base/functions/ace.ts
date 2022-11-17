type AllowDeny = "allow" | "deny";

function AddAce(principal: string, object: string, allowdeny: AllowDeny) {
  ExecuteCommand(`add_ace ${principal} ${object} ${allowdeny}`);
}

function AddPrincipal(child: string, parent: string) {
  ExecuteCommand(`add_principal ${child} ${parent}`);
}

function RemoveAce(principal: string, object: string, allowdeny: AllowDeny) {
  ExecuteCommand(`remove_ace ${principal} ${object} ${allowdeny}`);
}

function RemovePrincipal(child: string, parent: string) {
  ExecuteCommand(`remove_principal ${child} ${parent}`);
}

function TestAce(principal: string, object: string) {
  ExecuteCommand(`test_ace ${principal} ${object}`);
}
