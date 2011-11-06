
(function ($) {
    $.fn.count = function () {
        var count = 0;
        this.each(function () {
            count += 1;
            //max = Math.max(max, $(this).height()); 
        });
        return count;
    };
})(jQuery);


(function ($) {
    $.fn.plugin = function () {
        return this;
    };
})(jQuery);