/**
 * SMART RESTAURANT ORDERING & BILLING SYSTEM - CLIENT SCRIPTS
 */

document.addEventListener('DOMContentLoaded', function () {
    // Check if Area Selection modal should automatically display
    const areaModalEl = document.getElementById('areaSelectionModal');
    if (areaModalEl && areaModalEl.dataset.prompt === 'true') {
        const areaModal = new bootstrap.Modal(areaModalEl);
        areaModal.show();
    }

    // Add To Cart buttons listener
    document.querySelectorAll('.btn-add-cart').forEach(button => {
        button.addEventListener('click', function (e) {
            e.preventDefault();
            const itemId = this.dataset.itemId;
            const itemName = this.dataset.itemName;
            const qtyInput = document.getElementById('qty-' + itemId);
            const quantity = qtyInput ? qtyInput.value : 1;

            addItemToCart(itemId, quantity, false, itemName);
        });
    });

    // Conflict Modal "Clear & Proceed" button listener
    const confirmClearBtn = document.getElementById('btnConfirmClearCart');
    if (confirmClearBtn) {
        confirmClearBtn.addEventListener('click', function () {
            const pendingItemId = this.dataset.pendingItemId;
            const pendingQty = this.dataset.pendingQty || 1;
            if (pendingItemId) {
                addItemToCart(pendingItemId, pendingQty, true);
                const conflictModalEl = document.getElementById('cartConflictModal');
                const modal = bootstrap.Modal.getInstance(conflictModalEl);
                if (modal) modal.hide();
            }
        });
    }

    // Table Reservation: Live Availability Listener
    const restSelect = document.getElementById('resRestaurantSelect');
    const dateInput = document.getElementById('resDateInput');
    const slotSelect = document.getElementById('resSlotSelect');
    const guestInput = document.getElementById('resGuestInput');

    if (restSelect && dateInput && slotSelect && guestInput) {
        const checkAvailability = () => {
            const rId = restSelect.value;
            const date = dateInput.value;
            const slot = slotSelect.value;
            const guests = guestInput.value;

            if (rId && date && slot && guests) {
                fetch(`${window.contextPath || ''}/reserve-table?action=check-availability&restaurantId=${rId}&date=${date}&timeSlot=${encodeURIComponent(slot)}&guests=${guests}`)
                    .then(res => res.json())
                    .then(tables => {
                        const tableSelect = document.getElementById('resTableSelect');
                        if (tableSelect) {
                            tableSelect.innerHTML = '';
                            if (tables.length === 0) {
                                tableSelect.innerHTML = '<option value="">No tables available for this capacity/time slot</option>';
                                const submitBtn = document.getElementById('resSubmitBtn');
                                if (submitBtn) submitBtn.disabled = true;
                            } else {
                                tables.forEach(t => {
                                    const opt = document.createElement('option');
                                    opt.value = t.tableId;
                                    opt.textContent = `${t.tableNumber} (Capacity: ${t.capacity} guests)`;
                                    tableSelect.appendChild(opt);
                                });
                                const submitBtn = document.getElementById('resSubmitBtn');
                                if (submitBtn) submitBtn.disabled = false;
                            }
                        }
                    })
                    .catch(err => console.error('Availability check error:', err));
            }
        };

        restSelect.addEventListener('change', checkAvailability);
        dateInput.addEventListener('change', checkAvailability);
        slotSelect.addEventListener('change', checkAvailability);
        guestInput.addEventListener('change', checkAvailability);
    }
});

/**
 * Sends AJAX request to CartServlet
 */
function addItemToCart(itemId, quantity, forceClear, itemName) {
    const contextPath = window.contextPath || '';
    const formData = new URLSearchParams();
    formData.append('action', 'add');
    formData.append('itemId', itemId);
    formData.append('quantity', quantity);
    if (forceClear) {
        formData.append('forceClear', 'true');
    }

    fetch(`${contextPath}/cart`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // Update cart badge in navbar
            const badge = document.getElementById('navCartBadge');
            if (badge) {
                badge.textContent = data.totalCount;
                badge.classList.remove('d-none');
            }
            showToast('Item Added', `${itemName || 'Food item'} was added to your cart!`, 'success');
        } else if (data.conflict) {
            // Show Conflict Modal
            const conflictModalEl = document.getElementById('cartConflictModal');
            if (conflictModalEl) {
                document.getElementById('conflictMessage').textContent = data.message;
                const confirmBtn = document.getElementById('btnConfirmClearCart');
                confirmBtn.dataset.pendingItemId = itemId;
                confirmBtn.dataset.pendingQty = quantity;
                const modal = new bootstrap.Modal(conflictModalEl);
                modal.show();
            } else {
                alert(data.message);
            }
        } else {
            showToast('Notice', data.message || 'Could not add item.', 'warning');
        }
    })
    .catch(err => {
        console.error('Cart error:', err);
        showToast('Error', 'An error occurred while updating cart.', 'danger');
    });
}

/**
 * Toast Notification Helper
 */
function showToast(title, message, type = 'success') {
    let toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toastContainer';
        toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        toastContainer.style.zIndex = '9999';
        document.body.appendChild(toastContainer);
    }

    const toastEl = document.createElement('div');
    toastEl.className = `toast align-items-center text-bg-${type} border-0 show`;
    toastEl.setAttribute('role', 'alert');
    toastEl.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                <strong>${title}:</strong> ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;
    toastContainer.appendChild(toastEl);

    setTimeout(() => {
        toastEl.remove();
    }, 3500);
}

