document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('[data-crud-filter]').forEach(function (filter) {
        var table = document.getElementById(filter.dataset.crudFilter);
        var input = filter.querySelector('.crud-filter-input');
        var clearButton = filter.querySelector('.crud-filter-clear');
        var counter = filter.querySelector('.crud-filter-count');
        var rows = Array.from(table.querySelectorAll('tbody tr[data-record-row]'));
        var noResults = table.querySelector('.crud-no-results');

        function normalize(value) {
            return value.normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .toLocaleLowerCase('es')
                .trim();
        }

        function applyFilter() {
            var query = normalize(input.value);
            var visible = 0;

            rows.forEach(function (row) {
                var matches = !query || normalize(row.textContent).includes(query);
                row.style.display = matches ? '' : 'none';
                if (matches) {
                    visible++;
                }
            });

            counter.textContent = visible + (visible === 1 ? ' registro' : ' registros');
            noResults.style.display = visible === 0 ? 'table-cell' : 'none';
            clearButton.style.visibility = query ? 'visible' : 'hidden';
        }

        input.addEventListener('input', applyFilter);
        clearButton.addEventListener('click', function () {
            input.value = '';
            input.focus();
            applyFilter();
        });

        applyFilter();
    });
});
