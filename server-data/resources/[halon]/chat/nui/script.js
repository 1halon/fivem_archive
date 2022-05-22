window.addEventListener("DOMContentLoaded", function () {
    document.body.style.display = "none";
    const suggs = document.querySelector(".suggs"), suggestions = [], input = document.querySelector("input"), cmd_history = []; input.value = "/";

    window.onmessage = function (event) {
        const data = event.data;
        if (data.type === "AddSuggestion") {
            if (!suggestions.find(suggestion => suggestion.name === data.suggestion.name)) suggestions.push(elementize(data.suggestion));
        } else if (data.type === "ClearSuggestions") for (let index = 0; index < suggestions.length; index++) { suggestions.splice(index, 1); }
        else if (data.type === "RemoveSuggestion") suggestions.splice(suggestions.findIndex(suggestion => suggestion.name === data.name), 1);
        else if (data.type === "OverrideSuggestion") suggestions[suggestions.findIndex(suggestion => suggestion.name === data.name)] = data.suggestion;
        else if (data.type === "OFF") {
            document.body.style.display = "none"; suggs.innerHTML = ""; input.value = "/";
            suggestions.forEach(suggestion => suggestion.element.innerHTML = suggestion._element.innerHTML);
        } else if (data.type === "ON") {
            document.body.style.display = "flex"; input.focus();
        }
    }

    window.onkeydown = function (event) {
        if (document.activeElement === input) {
            if (event.which === 13) return fetch(`https://halon_chat/execute`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    commandString: input.value.slice(1)
                })
            }).then(res => res.json()).then(function () {
                cmd_history.push(input.value); window.postMessage({ type: "OFF" });
            }).catch(() => { });
            else if (event.which === 8 && input.value === "/" || [37, 38, 39, 40].indexOf(event.keyCode) > -1 || event.which === 32 && input.value === "/" || event.which === 65 && event.ctrlKey) return event.preventDefault();
            else if (event.which === 8 && event.shiftKey) { input.value = "/ "; document.querySelector(".arg.active")?.classList.remove("active"); }
            else if (event.which === 9) event.preventDefault();
            const value = event.which === 8 ? input.value.slice(0, -1) : input.value + (event.which < 32 || event.which > 127 ? "" : event.key), args = value.split(" ");
            const filtered_suggs = suggestions.filter(suggestion => value === "/" ? true : suggestion.name.startsWith(args[0])).slice(0, 3);
            if (filtered_suggs.length > 0) {
                suggs.innerHTML = "";
                if (args[0] !== "/") {
                    filtered_suggs.forEach(sugg => suggs.append(sugg.element));
                    if (filtered_suggs.length === 1 && filtered_suggs[0].name === args[0]) {
                        const sugg = filtered_suggs[0], _args = args.slice(1), active_arg = sugg.args[_args.length - 1], active_arg_element = document.querySelector(".arg.active");
                        if (active_arg) {
                            if (active_arg_element && active_arg.name !== active_arg_element.id) active_arg_element.classList.remove("active");
                            sugg.element.querySelector(`.arg[id="${active_arg.name}"]`)?.classList.add("active");
                            sugg.element.querySelector(`.desc`).innerHTML = active_arg.desc;
                        } else { sugg.element.querySelector(".desc").innerHTML = sugg.desc; if (active_arg_element) active_arg_element.classList.remove("active"); }
                    }
                }
            } else suggs.innerHTML = "";
        }
    }

    function elementize(sugg) {
        const { _element, args, desc, name } = sugg;
        if (!_element) {
            const html = `<div class="sugg" id="${name}">
            <div class="wrapper">
                <div class="name" title="${name}">${name}</div>
                ${args.map(arg => `<div class="arg${arg.required ? " required" : ""}" id="${arg.name}" title="${arg.name}">${arg.name}</div>`).join("")}
            </div>
            <div class="desc" title="${desc}">${desc}</div>
            </div>`, div = document.createElement("div"), _div = document.createElement("div"); div.innerHTML = html; _div.innerHTML = html;
            sugg.element = div.firstChild;
            sugg._element = _div.firstChild;
            return sugg;
        }
    }
});