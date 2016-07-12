window.setupPostForm = () => {
  function applySelect2($element, options) {
    let defaultOptions = {
      placeholder: '選択してください'
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

  applySelect2($('select#post_category_id'), {allowClear: false});
  applySelect2($('select#post_serial_id'), {allowClear: true});

  $(document).on('cocoon:after-insert', (e, inserted) => {
    let $element = $(inserted[0]);

    applySelect2($element.find('select'), {allowClear: false});
    setupCreditOrder($element);
  });
};
