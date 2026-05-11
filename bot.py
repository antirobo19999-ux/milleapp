import telebot
import os

TOKEN = "8647980914:AAG_zqv339LEDCmsXzD4pd7E64-QwV0mtmU"

bot = telebot.TeleBot(TOKEN)

@bot.message_handler(commands=['start'])
def start(message):
    bot.reply_to(message, "🤖 Bot activo")

@bot.message_handler(commands=['actualizarapp'])
def actualizar_app(message):

    chat_id = message.chat.id

    bot.send_message(chat_id, "🚀 Actualizando app...")

    resultado = os.system(
        "cd ~/panelhtml && netlify deploy --prod --dir . > deploy.log 2>&1"
    )

    if resultado == 0:
        bot.send_message(
            chat_id,
            "✅ App actualizada correctamente\n🌍 https://milleapp.netlify.app"
        )
    else:
        bot.send_message(
            chat_id,
            "❌ Error actualizando app"
        )

print("BOT ENCENDIDO")
bot.infinity_polling()
