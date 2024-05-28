type AllowDeny = "allow" | "deny";

export function AddAce(principal: string, object: string, allowdeny: AllowDeny) {
  ExecuteCommand(`add_ace ${principal} ${object} ${allowdeny}`);
}

export function AddPrincipal(child: string, parent: string) {
  ExecuteCommand(`add_principal ${child} ${parent}`);
}

export function RemoveAce(principal: string, object: string, allowdeny: AllowDeny) {
  ExecuteCommand(`remove_ace ${principal} ${object} ${allowdeny}`);
}

export function RemovePrincipal(child: string, parent: string) {
  ExecuteCommand(`remove_principal ${child} ${parent}`);
}

export function TestAce(principal: string, object: string) {
  ExecuteCommand(`test_ace ${principal} ${object}`);
}
