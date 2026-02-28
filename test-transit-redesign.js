const puppeteer = require('puppeteer');

async function testTransitRedesign() {
    console.log('🧪 Testing Public Transit Benefit Redesign...');
    
    const browser = await puppeteer.launch({ headless: false });
    const page = await browser.newPage();
    
    try {
        // Go to the employee dashboard
        console.log('📱 Navigating to employee dashboard...');
        await page.goto('http://localhost:3000/employee-dashboard.html');
        
        // Wait for page to load
        await page.waitForSelector('#sa-category', { timeout: 5000 });
        
        // Select Public Transit Benefit category
        console.log('🚍 Selecting Public Transit Benefit category...');
        await page.select('#sa-category', 'Public Transit Benefit');
        
        // Wait for transit form to appear
        await page.waitForSelector('#transit-form-container', { visible: true, timeout: 3000 });
        console.log('✅ Transit form appeared successfully');
        
        // Check if regular expense fields are hidden
        const regularFieldsHidden = await page.evaluate(() => {
            const fields = ['sa-date', 'sa-amount', 'sa-vendor', 'sa-description', 'sa-receipt'];
            return fields.every(id => {
                const element = document.getElementById(id);
                return element && element.closest('.form-group').style.display === 'none';
            });
        });
        
        if (regularFieldsHidden) {
            console.log('✅ Regular expense fields properly hidden');
        } else {
            console.log('❌ Regular expense fields not hidden properly');
        }
        
        // Check if transit form is visible
        const transitFormVisible = await page.evaluate(() => {
            const container = document.getElementById('transit-form-container');
            return container && container.style.display !== 'none';
        });
        
        if (transitFormVisible) {
            console.log('✅ Transit form is visible');
        } else {
            console.log('❌ Transit form is not visible');
        }
        
        // Check for new UI elements
        const newElements = await page.evaluate(() => {
            const elements = {
                claimCards: document.getElementById('transit-claim-cards'),
                addMonthBtn: document.getElementById('transit-add-month-btn'),
                submitBtn: document.getElementById('transit-submit-btn'),
                historySection: document.getElementById('transit-history-section'),
                noMonthsMsg: document.getElementById('transit-no-months')
            };
            
            return Object.fromEntries(
                Object.entries(elements).map(([key, elem]) => [key, !!elem])
            );
        });
        
        console.log('🔍 New UI elements check:', newElements);
        
        // Test switching back to regular category
        console.log('🔄 Testing category switch back...');
        await page.select('#sa-category', 'Meals');
        
        // Wait and check if fields are visible again
        await page.waitForTimeout(500);
        const regularFieldsVisible = await page.evaluate(() => {
            const fields = ['sa-date', 'sa-amount', 'sa-vendor', 'sa-description', 'sa-receipt'];
            return fields.every(id => {
                const element = document.getElementById(id);
                return element && element.closest('.form-group').style.display !== 'none';
            });
        });
        
        if (regularFieldsVisible) {
            console.log('✅ Regular fields restored when switching categories');
        } else {
            console.log('❌ Regular fields not restored properly');
        }
        
        console.log('🎉 Basic transit form test completed');
        
    } catch (error) {
        console.error('❌ Test failed:', error.message);
    } finally {
        await browser.close();
    }
}

// Only run if puppeteer is available
try {
    testTransitRedesign();
} catch (error) {
    console.log('⚠️ Puppeteer not available, skipping automated test');
    console.log('✅ Manual testing required at http://localhost:3000/employee-dashboard.html');
    console.log('1. Select "Public Transit Benefit" from category dropdown');
    console.log('2. Verify new card-based interface appears');
    console.log('3. Test month selection, amount entry, and receipt upload');
    console.log('4. Test "Add Another Month" functionality');
    console.log('5. Test form validation and submission');
}