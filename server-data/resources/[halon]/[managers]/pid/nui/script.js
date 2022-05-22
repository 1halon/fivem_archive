document.addEventListener("DOMContentLoaded", function () {
    document.body.style.display = "none";
    const inputs = document.querySelectorAll("input"), select = document.querySelector("select"), button = document.querySelector("button");

    inputs.forEach(function (input) {
        if (input.name === "firstname") {
            input.onkeydown = function (event) {
                if (event.which === 32) {
                    const value = input.value + event.key, args = value.split(" ").slice(0, -1);
                    input.value = args.map(arg => arg = arg[0].toUpperCase() + arg.slice(1)).join(" ");
                }
            }
        } else if (input.name === "surname") {
            input.onkeydown = function (event) {
                if (event.which === 32) return event.preventDefault();
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
            pid[name] = value;
        });
        button.disabled = true;
        return fetch(`https://halon_pid/create`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(pid)
        }).then(res => res.json()).then(function () {
            window.postMessage({ type: "OFF" });
        }).catch(() => { });
    }

    window.onmessage = function (event) {
        const data = event.data;
        if (data.type === "OFF") {
            document.body.style.display = "none"; inputs.forEach(input => input.value = input.getAttribute("value") || ""); button.disabled = false;
        } else if (data.type === "ON") {
            document.body.style.display = "flex";
        }
    }
});