document.addEventListener("DOMContentLoaded", () => {
  const contenedor = document.getElementById("contenedor-turnos");
  if (!contenedor) return;
  if (typeof window.turnos === "undefined" || !window.turnos.length) {
    contenedor.innerHTML = "<p style='color:#94a3b8;text-align:center;padding:40px'>Sin turnos cargados.</p>";
    return;
  }
  function fmt(t) {
    if (!t) return '-';
    const [h, m] = t.split(':').map(Number);
    const p = h >= 12 ? 'PM' : 'AM';
    const h12 = h % 12 || 12;
    return h12 + ':' + String(m).padStart(2,'0') + ' ' + p;
  }
  function crearCard(t) {
    return `<div class="card">
      <h3>${t.nombre}</h3>
      <p><b>Fecha:</b> ${t.fecha}</p>
      <p><b>Estado:</b> ${t.estado}</p>
      <p><b>Entrada:</b> ${fmt(t.entrada)}</p>
      <p><b>Salida:</b> ${fmt(t.salida)}</p>
      <p><b>Break 1:</b> ${fmt(t.break1)}</p>
      <p><b>Break 2:</b> ${fmt(t.break2)}</p>
      <p><b>Almuerzo:</b> ${fmt(t.almuerzo)}</p>
    </div>`;
  }
  contenedor.innerHTML = window.turnos.map(crearCard).join('');
});
