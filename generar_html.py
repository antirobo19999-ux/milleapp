import json

# Leer JSON
with open("turnobot_sync.json", "r", encoding="utf-8") as f:
    data = json.load(f)

html = """
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Panel TurnoBot</title>

<style>
body{
    background:#08152e;
    font-family:Arial;
    color:white;
    margin:0;
    padding:20px;
}

h1{
    text-align:center;
    color:#2fb4ff;
}

.grid{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(300px,1fr));
    gap:20px;
}

.card{
    background:#17233d;
    border-radius:20px;
    padding:20px;
    box-shadow:0 0 10px rgba(0,0,0,.3);
}

.nombre{
    color:#2fb4ff;
    font-size:24px;
    font-weight:bold;
    margin-bottom:10px;
}

.estado{
    background:#16a34a;
    display:inline-block;
    padding:8px 15px;
    border-radius:10px;
    margin-top:10px;
    font-weight:bold;
}

.info{
    margin:4px 0;
    font-size:18px;
}
</style>
</head>

<body>

<h1>📊 Panel TurnoBot</h1>

<div class="grid">
"""

for item in data:

    html += f"""
    <div class="card">
        <div class="nombre">{item.get('nombre','N/D')}</div>

        <div class="info">📅 Fecha: {item.get('fecha','N/D')}</div>
        <div class="info">🕒 Entrada: {item.get('entrada','N/D')}</div>
        <div class="info">🕔 Salida: {item.get('salida','N/D')}</div>
        <div class="info">☕ Break 1: {item.get('break1','N/D')}</div>
        <div class="info">☕ Break 2: {item.get('break2','N/D')}</div>
        <div class="info">🍽️ Almuerzo: {item.get('almuerzo','N/D')}</div>

        <div class="estado">{item.get('estado','N/D')}</div>
    </div>
    """

html += """
</div>
</body>
</html>
"""

with open("panel_turnobot.html", "w", encoding="utf-8") as f:
    f.write(html)

print("HTML generado: panel_turnobot.html")


