jQuery(($) => {
  if (!$("#color-selector").length) {
    return;
  }

  $("#color-selector").spectrum({
    allowEmpty: true,
    color: "#6f9966",
    cancelText: "Cancel",
    hide(tinycolor) {
      setColor(tinycolor);
    }
  });

  $(".sp-preview-inner").append(
    `<div class="light-transparency"></div>
    <div class="middle-transparency"></div>
    <div class="original-transparency"></div>`
  );

  restoreHue();

  function setColor(tinycolor) {
    let hue;
    if (tinycolor) {
      hue = Math.round(tinycolor.toHsl().h);
    } else {
      hue = null;
    }
    $("#site_base_hue").val(hue);
  }

  function restoreHue() {
    let hue = $("#site_base_hue").val();
    let hsl;

    if (hue) {
      hsl = $("#color-selector").spectrum("get").toHsl();
      hsl.h = hue;
    } else {
      hsl = null;
    }

    $("#color-selector").spectrum("set", hsl);
  }
});
