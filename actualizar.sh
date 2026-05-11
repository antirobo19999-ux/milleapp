#!/data/data/com.termux/files/usr/bin/bash
cd ~/turnobot

# 1. Inyectar DATA
node -e "
const db = require('./database');
const fs = require('fs');
function fmt12(t) {
  if (!t) return null;
  const [h, m] = t.split(':').map(Number);
  const p = h >= 12 ? 'PM' : 'AM';
  const h12 = h % 12 || 12;
  return h12 + ':' + String(m).padStart(2,'0') + ' ' + p;
}
function addMin(t, mins) {
  if (!t) return null;
  const [h, m] = t.split(':').map(Number);
  const total = h * 60 + m + mins;
  return String(Math.floor(total/60)%24).padStart(2,'0') + ':' + String(total%60).padStart(2,'0');
}
function calcHoras(e, s, a) {
  if (!e || !s) return 0;
  const [eh,em] = e.split(':').map(Number);
  const [sh,sm] = s.split(':').map(Number);
  let d = (sh*60+sm)-(eh*60+em);
  if(d<0) d+=1440;
  if(a) d-=60;
  return Math.round(d/60*100)/100;
}
const records = db.getRecords().map(r => ({
  ...r,
  horas: calcHoras(r.entrada, r.salida, r.almuerzo),
  entrada12: fmt12(r.entrada), salida12: fmt12(r.salida),
  break1_12: fmt12(r.break1), break1_fin12: fmt12(addMin(r.break1,15)),
  break2_12: fmt12(r.break2), break2_fin12: fmt12(addMin(r.break2,15)),
  alm12: fmt12(r.almuerzo), alm_fin12: fmt12(addMin(r.almuerzo,60))
}));
const htmlPath = process.env.HOME + '/panelhtml/index.html';
let html = fs.readFileSync(htmlPath, 'utf8');
html = html.replace(/const DATA\s*=\s*\[[\s\S]*?\];/, 'const DATA = ' + JSON.stringify(records) + ';');
fs.writeFileSync(htmlPath, html, 'utf8');
console.log('DATA: ' + records.length + ' registros');
"

# 2. Actualizar TODAY, BACKEND y cache-bust
python3 -c "
import re, time, subprocess
path = '/data/data/com.termux/files/home/panelhtml/index.html'
html = open(path).read()
from datetime import datetime
today = datetime.now().strftime('%d/%m/%Y')
ts = str(int(time.time()))
# Obtener IP local del dispositivo
try:
    ip = subprocess.check_output(['ip','route','get','1.1.1.1'], text=True)
    ip = re.search(r'src (\d+\.\d+\.\d+\.\d+)', ip).group(1)
except:
    ip = '127.0.0.1'
html = re.sub(r\"const TODAY = '[^']*'\", \"const TODAY = '\" + today + \"'\", html)
html = re.sub(r\"const BACKEND = '[^']*'\", \"const BACKEND = 'http://\" + ip + \":3001'\", html)
html = re.sub(r'data-v=\"[^\"]*\"', 'data-v=\"' + ts + '\"', html)
open(path,'w').write(html)
print('TODAY: ' + today + ' | BACKEND: http://' + ip + ':3001 | bust: ' + ts)
"

# 3. Push a GitHub
cd ~/panelhtml
git add index.html
git commit -m "sync $(date '+%d/%m/%Y %H:%M')" --allow-empty
git push origin main
echo "Publicado en https://antirobo19999-ux.github.io/milleapp/index.html"
