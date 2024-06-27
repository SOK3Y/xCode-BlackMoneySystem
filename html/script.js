const cont = document.getElementById("moneyWashCont"),
amountMoney = document.getElementById("amountMoney");

let Post = async function(name, data = {}){
    try {
        let resp = await fetch(`https://${GetParentResourceName()}/${name}`,{
            method: "POST",
            mode: "same-origin",
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json; charset=UTF-8"
            },
            body: JSON.stringify(data || {})
        });
        if(!resp.ok){
            return;
        }
        return await resp.json();
    }catch(err){}
}

function Show(){
    cont.style.display = "block";
    cont.classList.remove("hide");
    cont.classList.add("show");
}

function Close(){
    setTimeout(function(){
        Post("close");
        cont.style.display = "none";
    }, 600);
    cont.classList.remove("show");
    cont.classList.add("hide");
}

const btn = document.getElementById("btn");
btn.addEventListener("click", function(){
    Close();
    Post("result", {result: amountMoney.value})
});

const icon = document.getElementById("iconImg");
icon.addEventListener("click", function(){
    Close();
});

window.addEventListener("keydown", function(e){
    if(e.code=="Escape"){
        Close();
    }
});

window.addEventListener("message", function(event){
    const e = event.data;
    if(e.action == "show"){
        Show();
    }
});