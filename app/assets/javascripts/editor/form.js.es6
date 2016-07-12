$(() => {
  function applySelect2(selector, options) {
    let $element = $(selector);
    let defaultOptions = {
      placeholder: '選択してください',
      allowClear: $element.data("select2-allow-clear")
    };
    let mergedOptions = $.extend(defaultOptions, options);
    $element.select2(mergedOptions);
  }

  function setupCreditOrder($element) {
    let orders = $('.credit-order-value').map((_i, el) => {
      return Number($(el).val());
    });

    orders.push(0); // Minimum value

    let maxOrder = Math.max(...orders);
    $element.find('.credit-order-value').val(maxOrder + 1);
  }

  applySelect2('select.select2', {});

  $(document).on('cocoon:after-insert', (e, inserted) => {
    let $element = $(inserted[0]);

    applySelect2($element.find('select'), {allowClear: false});
    setupCreditOrder($element);
  });
});
