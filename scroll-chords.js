const sc_el = document.getElementById("auto-scroll-opts");
const MAX_SPEED = 30;

let s_btn = null, set_speed = null, scroll_speed = 10, scroller;

function start_scrolling() {
  s_btn.onclick = stop_scrolling;
  s_btn.innerHTML = "stop";

  scroller = () => {
    window.scrollTo({top: window.scrollY + scroll_speed, behavior: 'smooth'});
    if (!((window.innerHeight + window.scrollY) >= document.body.scrollHeight))
      setTimeout(scroller, 1000);
    else
      stop_scrolling();
  }

  scroller(0);
}

function stop_scrolling() {
  s_btn.onclick = start_scrolling;
  s_btn.innerHTML = "start";

  scroller = _ => 0;
}

function init() {
  const as_lbl = document.createElement("label");
  const speed_lbl = document.createElement("label");

  const plusb  = document.createElement("button");
  const minusb = document.createElement("button");

  plusb.innerHTML  = "+";
  minusb.innerHTML = "-";

  s_btn = document.createElement("button");
  as_lbl.innerHTML = "auto-scroll:";

  set_speed = y => {
    const x = Math.min(Math.max(y, 0), MAX_SPEED);
    scroll_speed = x;
    speed_lbl.innerHTML = ` prędkość: ${x} (px / sec)`;
  };

  set_speed(12);

  plusb.onclick  = _ => set_speed(scroll_speed + 1);
  minusb.onclick = _ => set_speed(scroll_speed - 1);

  sc_el.appendChild(as_lbl);
  sc_el.appendChild(s_btn);
  sc_el.appendChild(speed_lbl);

  sc_el.appendChild(plusb);
  sc_el.appendChild(minusb);

  stop_scrolling();
}

init();
