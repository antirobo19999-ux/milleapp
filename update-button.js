
async function actualizarApp() {

  const clave = prompt("Clave admin:");

  if(clave !== "1234"){
    alert("Clave incorrecta");
    return;
  }

  try {

    await fetch(
      "https://api.telegram.org/bot8647980914:AAG_zqv339LEDCmsXzD4pd7E64-QwV0mtmU/sendMessage",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          chat_id: "",
          text: "/actualizarapp"
        })
      }
    );

    alert("✅ Actualización enviada");

  } catch(err) {

    alert("❌ Error actualizando");

  }

}

