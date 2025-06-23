document.addEventListener('DOMContentLoaded', function() {
    const osCards = document.querySelectorAll('.os-card');
    const form = document.querySelector('form');
    const lightThemeBtn = document.getElementById('lightTheme');
    const darkThemeBtn = document.getElementById('darkTheme');
    const html = document.documentElement;
    const configContainer = document.getElementById('configContainer');
    const windowsOnlyElements = document.querySelectorAll('.windows-only');
    const macOnlyElements = document.querySelectorAll('.mac-only');

    // Theme Management
    function setTheme(theme) {
        if (theme === 'dark') {
            html.classList.add('dark');
            html.classList.remove('light');
            darkThemeBtn.classList.add('active');
            lightThemeBtn.classList.remove('active');
        } else {
            html.classList.remove('dark');
            html.classList.add('light');
            lightThemeBtn.classList.add('active');
            darkThemeBtn.classList.remove('active');
        }
        localStorage.setItem('theme', theme);
    }

    // Initialize theme based on system preference or saved preference
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const savedTheme = localStorage.getItem('theme');
    setTheme(savedTheme || (prefersDark ? 'dark' : 'light'));

    // Theme button listeners
    lightThemeBtn.addEventListener('click', () => setTheme('light'));
    darkThemeBtn.addEventListener('click', () => setTheme('dark'));

    // Function to toggle OS-specific elements
    function toggleOSElements(os) {
        console.log('Toggling OS elements for:', os);
        
        // Remove all OS classes from the config container
        configContainer.classList.remove('windows', 'macos');
        
        // Add the selected OS class to the config container
        configContainer.classList.add(os);

        // Handle Windows Architecture selection
        if (os === 'macos') {
            // Clear and disable Windows-specific fields
            const winUser = document.getElementById('winUser');
            const winPass = document.getElementById('winPass');
            const winArch = document.getElementById('winArch');
            const winVariant = document.getElementById('winVariant');

            if (winUser) {
                winUser.value = '';
                winUser.disabled = true;
            }
            if (winPass) {
                winPass.value = '';
                winPass.disabled = true;
            }
            if (winArch) {
                winArch.value = 'x86';
                winArch.disabled = true;
            }
            if (winVariant) {
                winVariant.value = '';
                winVariant.disabled = true;
            }

            // Enable macOS fields
            const macVariant = document.getElementById('macVariant');
            if (macVariant) {
                macVariant.disabled = false;
                // Set default option selected for macVariant
                if (macVariant.options.length > 0) {
                    macVariant.selectedIndex = 0;
                }
            }
        } else if (os === 'windows' || os === 'windows-arm') {
            // Enable Windows-specific fields
            const winUser = document.getElementById('winUser');
            const winPass = document.getElementById('winPass');
            const winArch = document.getElementById('winArch');
            const winVariant = document.getElementById('winVariant');

            if (winUser) {
                winUser.disabled = false;
            }
            if (winPass) {
                winPass.disabled = false;
            }
            if (winArch) {
                winArch.disabled = false;
            }
            if (winVariant) {
                winVariant.disabled = false;
                // Set default option selected for winVariant
                if (winVariant.options.length > 0) {
                    winVariant.selectedIndex = 0;
                }
            }

            // Clear and disable macOS fields
            const macVariant = document.getElementById('macVariant');
            if (macVariant) {
                macVariant.value = '';
                macVariant.disabled = true;
            }
        }
    }

    // Handle Windows Architecture selection
    const winArchSelect = document.getElementById('winArch');
    const archIcon = document.getElementById('archIcon');

    if (winArchSelect && archIcon) {
        winArchSelect.addEventListener('change', function() {
            // Update icon based on architecture selection
            if (this.value === 'arm') {
                archIcon.classList.remove('fa-microchip');
                archIcon.classList.add('fa-mobile');
                archIcon.classList.add('text-purple-500');
                archIcon.classList.remove('text-gray-500');
            } else {
                archIcon.classList.add('fa-microchip');
                archIcon.classList.remove('fa-mobile');
                archIcon.classList.add('text-gray-500');
                archIcon.classList.remove('text-purple-500');
            }
        });
    }

    // Handle card selection
    osCards.forEach(card => {
        // Add click event listener
        card.addEventListener('click', function(e) {
            // Prevent default label behavior if it's a label
            e.preventDefault();
            
            console.log('Card clicked:', this.dataset.os);
            
            // Remove selected class from all cards
            osCards.forEach(c => {
                c.classList.remove('selected');
                c.classList.remove('ring-2', 'ring-blue-500');
            });
            
            // Add selected class to clicked card
            this.classList.add('selected');
            this.classList.add('ring-2', 'ring-blue-500');
            
            // Check the radio button
            const radio = this.querySelector('input[type="radio"]');
            if (radio) {
                radio.checked = true;
            }

            // Get the OS type from the data attribute
            const os = this.dataset.os;
            console.log('Selected OS:', os);

            // Update the name parameter based on OS selection
            const name = `${os.charAt(0).toUpperCase() + os.slice(1)}-1`;
            
            // Update or create the name parameter in the form action URL
            const currentAction = form.action;
            const url = new URL(currentAction);
            url.searchParams.set('name', name);
            form.action = url.toString();

            // Toggle OS-specific elements
            toggleOSElements(os);
        });

        // Also add change event listener for radio buttons
        const radio = card.querySelector('input[type="radio"]');
        if (radio) {
            radio.addEventListener('change', function() {
                if (this.checked) {
                    const os = this.value;
                    console.log('Radio changed to:', os);
                    toggleOSElements(os);
                }
            });
        }
    });

    // Select Windows card by default
    const windowsCard = document.querySelector('[data-os="windows"]');
    if (windowsCard) {
        windowsCard.click();
    }

    // Password Toggle Functionality
    try {
        const togglePasswordButtons = document.querySelectorAll('.toggle-password');
        
        togglePasswordButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Get the target input's id from data attribute
                const targetId = this.getAttribute('data-toggle-target');
                const passwordInput = document.getElementById(targetId);

                if (!passwordInput) {
                    console.error(`Password input with id "${targetId}" not found.`);
                    return;
                }

                // Toggle the input type
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    this.setAttribute('aria-label', 'Hide Password');
                    this.innerHTML = '<i class="fas fa-eye-slash"></i>';
                } else {
                    passwordInput.type = 'password';
                    this.setAttribute('aria-label', 'Show Password');
                    this.innerHTML = '<i class="fas fa-eye"></i>';
                }
            });
        });
    } catch (error) {
        console.error('Error initializing password toggle functionality:', error);
    }

    // Form submission handling
    form.addEventListener('submit', function(e) {
        try {
        // Clear previous error messages and styles
        function clearError(id) {
            const errorElem = document.getElementById(id);
            if (errorElem) {
                errorElem.classList.add('hidden');
            }
            const inputElem = document.querySelector(`[aria-describedby="${id}"]`) || document.getElementById(id.replace('Error', ''));
            if (inputElem) {
                inputElem.classList.remove('border-red-600', 'focus:ring-red-600');
            }
        }

        function showError(id) {
            const errorElem = document.getElementById(id);
            if (errorElem) {
                errorElem.classList.remove('hidden');
            }
            const inputElem = document.querySelector(`[aria-describedby="${id}"]`) || document.getElementById(id.replace('Error', ''));
            if (inputElem) {
                inputElem.classList.add('border-red-600', 'focus:ring-red-600');
            }
        }

        // Clear all errors initially
        clearError('osError');
        clearError('winVariantError');
        clearError('winUserError');
        clearError('winPassError');
        clearError('macVariantError');

        // Check OS selection
        const selectedOs = document.querySelector('input[name="osVariant"]:checked');
        if (!selectedOs) {
            e.preventDefault();
            showError('osError');
            return;
        }

        const isWindows = selectedOs.value === 'windows' || selectedOs.value === 'windows-arm';
        const isMacOS = selectedOs.value === 'macos';

        // Before submission, clear and disable irrelevant fields to prevent sending unused params
        if (isMacOS) {
            const winUser = document.getElementById('winUser');
            const winPass = document.getElementById('winPass');
            const winArch = document.getElementById('winArch');
            const winVariant = document.getElementById('winVariant');

            if (winUser) {
                winUser.value = '';
                winUser.disabled = true;
            }
            if (winPass) {
                winPass.value = '';
                winPass.disabled = true;
            }
            if (winArch) {
                winArch.value = 'x86';
                winArch.disabled = true;
            }
            if (winVariant) {
                winVariant.value = '';
                winVariant.disabled = true;
            }
        } else if (isWindows) {
            const macVariant = document.getElementById('macVariant');
            if (macVariant) {
                macVariant.value = '';
                macVariant.disabled = true;
            }
        }

        if (isWindows) {
            // Validate Windows variant
            if (document.getElementById('winVariant').value === '') {
                e.preventDefault();
                showError('winVariantError');
                return;
            }

            // Validate username
            const username = document.getElementById('winUser').value.trim();
            if (!username) {
                e.preventDefault();
                showError('winUserError');
                return;
            }

            // Validate password
            const password = document.getElementById('winPass').value;
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            if (!passwordRegex.test(password)) {
                e.preventDefault();
                showError('winPassError');
                return;
            }
        } else if (isMacOS) {
            // Validate macOS variant
            if (document.getElementById('macVariant').value === '') {
                e.preventDefault();
                showError('macVariantError');
                return;
            }
        }
        } catch (error) {
            console.error('Error during form submission:', error);
        }
    });
});
