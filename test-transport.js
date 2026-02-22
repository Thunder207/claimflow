        function tdpToggleTransport(mode) {
            const button = document.querySelector(`[data-mode="${mode}"]`);
            const section = document.getElementById(`tdp-${mode}-section`);
            const isActive = button.classList.contains('active');
            
            if (isActive) {
                // Deactivate
                button.classList.remove('active');
                button.style.backgroundColor = 'white';
                button.style.borderColor = '#6c757d';
                button.style.color = '#6c757d';
                section.style.display = 'none';
                
                // Clear values for deactivated mode
                clearTransportMode(mode);
            } else {
                // Activate
                button.classList.add('active');
                button.style.backgroundColor = '#17a2b8';
                button.style.borderColor = '#17a2b8';
                button.style.color = 'white';
                section.style.display = 'block';
            }
            
            // Handle special case for personal vehicle - show/hide vehicle section
            if (mode === 'personal') {
                const vehicleSection = document.getElementById('tdp-vehicle-section');
                if (vehicleSection) {
                    vehicleSection.style.display = isActive ? 'none' : 'block';
                }
            }
            
            // Recalculate total
            tdpRecalcTotal();
            
            // Save transport preferences
            saveTdpTransport();
        }

        function clearTransportMode(mode) {
            // Clear all inputs for this transport mode
            const inputs = document.querySelectorAll(`#tdp-${mode}-section input`);
            inputs.forEach(input => {
                input.value = '';
            });
            
            // Update subtotal
            const subtotalEl = document.getElementById(`tdp-${mode}-total`);
            if (subtotalEl) {
                subtotalEl.textContent = '$0.00';
            }
