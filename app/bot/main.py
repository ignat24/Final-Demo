import telebot

API_TOKEN = '2144331292:AAG2F3nOufD70TVURRzHuTrJ3fNytutb6eI'
bot = telebot.TeleBot(API_TOKEN)


@bot.message_handler(commands=['help', 'start'])
def send_welcome(message):
    if message.text == '/start':
        bot.reply_to(message, """\
    Hi there, I am TimeBot.

Codebuild here!

I am here to help you don't forgot your timetable of classes!\
    """)
    else:
        bot.reply_to(message, """\
    Hi there, I am TimeBot.
I know the schedule for 5 days (Monday, Tuesday, Wednesday, Thursday, Friday)!
    """)
    


file = open("text.txt" , 'r')
temp = file.read()
timetable = temp.split("\n\n")

@bot.message_handler(content_types=['text'])
def send_text(message):
    if message.text.lower() == 'monday':
        bot.send_message(message.chat.id, timetable[0])
    if message.text.lower() == 'tuesday':
        bot.send_message(message.chat.id, timetable[1])
    if message.text.lower() == 'wednesday':
        bot.send_message(message.chat.id, timetable[2])
    if message.text.lower() == 'thursday':
        bot.send_message(message.chat.id, timetable[3])
    if message.text.lower() == 'friday':
        bot.send_message(message.chat.id, timetable[4])

bot.infinity_polling()