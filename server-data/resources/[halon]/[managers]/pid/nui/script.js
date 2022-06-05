document.addEventListener("DOMContentLoaded", function () {
    const inputs = document.querySelectorAll("input"), select = document.querySelector("select"), button = document.querySelector("button");

    document.querySelector("input[type='date']").max = new Date(new Date().setFullYear(new Date().getFullYear() - 18)).toISOString().split("T")[0];

    inputs.forEach(function (input) {
        if (input.name === "firstname") {
            input.onkeydown = function (event) {
                if (event.key === " ") {
                    const value = input.value + event.key, args = value.split(" ").slice(0, -1);
                    input.value = args.map(arg => arg = arg[0].toUpperCase() + arg.slice(1)).join(" ");
                }
            }
        } else if (input.name === "surname") {
            input.onkeydown = function (event) {
                if (event.key === " ") return event.preventDefault();
                input.value = input.value[0] ? input.value[0].toUpperCase() + input.value.slice(1) : "";
            }
        }
    });

    button.onclick = function () {
        const pid = { [select.name]: select.value }
        inputs.forEach(function (input) {
            const { max, min, name, type, value } = input;
            if (max && (type === "number" && value > max || type === "text" && value.length > max)) throw "MAXV";
            if (min && (type === "number" && value < min || type === "text" && value.length < min)) throw "MINV";
            if (name) {
                if (name === "firstname")
                    input.value = input.value.split(" ")
                        .filter(value => value !== "").map(arg => arg = arg[0].toUpperCase() + arg.slice(1)).join(" ");
                else if (name === "surname") input.value = input.value.toUpperCase();
            }
            pid[name] = input.value;
        });
        disabled(true);
        return fetch("https://halon_pid/create", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(pid)
        }).then(res => res.json()).then(function () {
            window.postMessage({ type: "OFF" });
        }).catch(() => { })
            .finally(() => disabled(false));
    }

    window.onmessage = function (event) {
        const data = event.data;
        if (data.type === "OFF") {
            document.body.style.display = "none"; inputs.forEach(input => input.value = input.getAttribute("value") || ""); button.disabled = false;
        } else if (data.type === "ON") {
            document.body.style.display = "flex";
        }
    }

    function disabled(state) {
        button.disabled = state;
        inputs.forEach(input => input.disabled = state);
        select.disabled = state;
    }
});