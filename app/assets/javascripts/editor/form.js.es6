$(() => {
  function applySelect2(selector) {
    let $element = $(selector);
    let options = {
      placeholder: '選択してください',
      allowClear: $element.data("select2-allow-clear")
    };
    $element.select2(options);
  }

  function setupOrder($element, target) {
    let orders = $(target).map((_i, el) => {
      return Number($(el).val());
    }).toArray();

    orders.push(0); // Minimum value

    let maxOrder = Math.max(...orders);
    $element.find(target).val(maxOrder + 1);
  }

  applySelect2('select.select2');

  $(document).on('cocoon:after-insert', (e, inserted) => {
    let $element = $(inserted[0]);

    applySelect2($element.find('select.select2'));
    setupOrder($element, '.credit-order-value');
    setupOrder($element, '.categorization-order-value')
  });
});
