---@alias allowdeny "allow" | "deny"

---@param principal string
---@param object string
---@param allowdeny allowdeny
function AddAce(principal, object, allowdeny)
    ExecuteCommand(string.format("add_ace %s %s %s", principal, object, allowdeny))
end

---@param child_principal string
---@param parent_principal string
function AddPrincipal(child_principal, parent_principal)
    ExecuteCommand(string.format("add_principal %s %s", child_principal, parent_principal))
end

---@param principal string
---@param object string
---@param allowdeny allowdeny
function RemoveAce(principal, object, allowdeny)
    ExecuteCommand(string.format("remove_ace %s %s %s", principal, object, allowdeny))
end

---@param child_principal string
---@param parent_principal string
function RemovePrincipal(child_principal, parent_principal)
    ExecuteCommand(string.format("add_principal %s %s", child_principal, parent_principal))
end

---@param principal string
---@param object string
function TestAce(principal, object)
    ExecuteCommand(string.format("test_ace %s %s", principal, object))
end
