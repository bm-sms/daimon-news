jQuery(($) => {
  if (!$("#color-selector").length) {
    return;
  }

  $("#color-selector").spectrum({
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
    $("#site_base_hue").val(Math.round(tinycolor.toHsl().h));
  }

  function restoreHue() {
    let hue = $("#site_base_hue").val();
    let hsl = $("#color-selector").spectrum("get").toHsl();

    hsl.h = hue;

    $("#color-selector").spectrum("set", hsl);
  }
});
