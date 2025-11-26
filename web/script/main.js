
const init = () => {
    // Any other initialization code can go here
    console.log('Notification function initialized');
    
    // Request notification permission early during initialization
    // This needs to be triggered by a user interaction elsewhere in the app
    const requestNotificationPermission = async () => {
        if (!('Notification' in window)) {
            console.log('This browser does not support notifications');
            return false;
        }
        
        if (Notification.permission === 'granted') {
            console.log('Notification permission already granted');
            return true;
        } else if (Notification.permission !== 'denied') {
            try {
                const permission = await Notification.requestPermission();
                return permission === 'granted';
            } catch (error) {
                console.error('Error requesting notification permission:', error);
                return false;
            }
        } else {
            console.log('Notification permission denied');
            return false;
        }
    };

    const showOnGranted = (title, message, hash) => {
        // Permission already granted, show notification
        try {
            const notification = new Notification(title, {
                body: message,
                icon: '/logo_signet.svg', // Add an icon if available
                tag: hash, // Prevent duplicate notifications
                requireInteraction: false, // Don't require user interaction to dismiss
                silent: false, // Allow sound
                data: {
                    url: '/notifications/' + hash,
                }
            });
            
            console.log('Notification object created:', notification);
            console.log('Notification shown successfully');
            
            // Add event listeners to debug notification behavior
            notification.onshow = () => {
                console.log('Notification actually displayed');
            };
            
            notification.onerror = (error) => {
                console.error('Notification error event:', error);
            };
            
            notification.onclose = () => {
                console.log('Notification closed');
            };
            
            notification.onclick = () => {
                console.log('Notification clicked');
                window.focus(); // Bring window to front when clicked
                
                // Navigate to the deep link URL if provided
                if (notification.data && notification.data.url) {
                    console.log('Navigating to:', notification.data.url);
                    window.location.href = notification.data.url;
                }
            };
            
            // Keep a reference to prevent garbage collection
            window._lastNotification = notification;
            
            return notification;
        } catch (error) {
            console.error('Error showing notification:', error);
            console.error('Error details:', error.message, error.stack);
            alert(message); // Fallback to alert
        }
    };
    
    // Define the notification function globally so it's available immediately
    const showLocalNotification = async (message, hash, title = 'Notification') => {
        console.log('Attempting to show notification:', message);
        console.log('Current permission state:', Notification.permission);
        console.log('Document visibility state:', document.visibilityState);
        console.log('Window focus state:', document.hasFocus());
        
        if (!('Notification' in window)) {
            // Fallback if notifications not supported
            console.log('Notifications not supported, showing alert');
            alert(message);
            return;
        }
        
        // Check current permission state
        if (Notification.permission === 'granted') {
            return showOnGranted(title, message, hash);
        } else if (Notification.permission !== 'denied') {
            // Need to request permission
            try {
                console.log('Requesting notification permission...');
                const permission = await Notification.requestPermission();
                console.log('Permission result:', permission);
                
                if (permission === 'granted') {
                    return showOnGranted(title, message, hash);
                } else {
                    // Permission denied, fallback to alert
                    console.log('Permission denied, showing alert');
                    alert(message);
                }
            } catch (error) {
                console.error('Error in permission request:', error);
                alert(message); // Fallback to alert
            }
        } else {
            // Permission previously denied, fallback to alert
            console.log('Permission previously denied, showing alert');
            alert(message);
        }
    };

    // Test function to debug notification issues
    const testNotification = () => {
        console.log('=== NOTIFICATION DEBUG TEST ===');
        console.log('Notification support:', 'Notification' in window);
        console.log('Current permission:', Notification.permission);
        console.log('Document visibility:', document.visibilityState);
        console.log('Document has focus:', document.hasFocus());
        console.log('User agent:', navigator.userAgent);
        
        // Test with a simple notification
        showLocalNotification('Test notification - if you see this in console but no notification appears, there may be a system-level issue', 'Debug Test');
    };
    
    // Make the functions available on the window object immediately
    window._showLocalNotification = showLocalNotification;
    window._requestNotificationPermission = requestNotificationPermission;
    window._testNotification = testNotification;
}

window.onload = () => {
    init();
}