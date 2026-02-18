#!/usr/bin/env node

/**
 * DIAGNOSE THE ACTUAL ISSUE Tony is experiencing
 * Let's find out exactly what's happening when he clicks the button
 */

const fs = require('fs');
const { exec } = require('child_process');

console.log('🔍 DIAGNOSING "Please select a trip first!" ERROR');
console.log('===============================================');

// Step 1: Check if server is actually running
console.log('\n1️⃣ Checking server status...');
exec('curl -s -I http://localhost:3000', (error, stdout, stderr) => {
    if (error) {
        console.log('❌ Server not accessible:', error.message);
        return;
    }
    
    if (stdout.includes('200 OK')) {
        console.log('✅ Server is running and accessible');
        
        // Step 2: Get the actual HTML being served
        exec('curl -s http://localhost:3000/dashboard', (error, stdout, stderr) => {
            if (error) {
                console.log('❌ Could not fetch dashboard:', error.message);
                return;
            }
            
            console.log('\n2️⃣ Analyzing served HTML...');
            
            // Check for the exact button
            if (stdout.includes('onclick="addIndividualExpense()"')) {
                console.log('✅ Individual expense button found with correct onclick');
            } else {
                console.log('❌ Individual expense button missing or incorrect onclick');
            }
            
            // Check for function definition
            if (stdout.includes('function addIndividualExpense()')) {
                console.log('✅ addIndividualExpense() function definition found');
            } else {
                console.log('❌ addIndividualExpense() function definition missing');
            }
            
            // Check if there are any obvious JavaScript errors
            const jsErrors = [
                stdout.includes('SyntaxError'),
                stdout.includes('ReferenceError'),
                stdout.includes('TypeError'),
                stdout.includes('undefined is not a function')
            ];
            
            if (jsErrors.some(error => error)) {
                console.log('❌ JavaScript errors detected in HTML');
            } else {
                console.log('✅ No obvious JavaScript errors detected');
            }
            
            // Check for the error message source
            const errorPattern = /Please select a trip first/g;
            const matches = stdout.match(errorPattern);
            if (matches) {
                console.log(`✅ Found ${matches.length} instances of "Please select a trip first" message`);
            } else {
                console.log('❌ "Please select a trip first" message not found in HTML');
            }
            
            console.log('\n3️⃣ DIAGNOSIS COMPLETE');
            console.log('=====================');
            
            console.log('\n🎯 POSSIBLE CAUSES OF THE ERROR:');
            console.log('1. Browser cache - Tony might be seeing old cached version');
            console.log('2. JavaScript error preventing function from being defined');
            console.log('3. Event handler conflict or button onclick being overridden');
            console.log('4. Form validation triggering wrong code path');
            console.log('5. Multiple script tags or function redefinition conflicts');
            
            console.log('\n🔧 IMMEDIATE DEBUGGING STEPS FOR TONY:');
            console.log('1. Hard refresh the page (Ctrl+Shift+R or Cmd+Shift+R)');
            console.log('2. Open browser console (F12) BEFORE clicking the button');
            console.log('3. Look for any JavaScript errors in red');
            console.log('4. Click the blue "Add Individual Expense" button');
            console.log('5. Check what appears in the console log');
            console.log('6. Tell me exactly what console messages appear');
            
            console.log('\n🚨 IF THE ISSUE PERSISTS:');
            console.log('The problem is likely a browser caching issue or a JavaScript runtime error');
            console.log('that only occurs when the full page is loaded in the browser.');
        });
    } else {
        console.log('❌ Server responded but not with 200 OK');
    }
});

// Step 3: Create a minimal test file
console.log('\n4️⃣ Creating minimal test file...');

const minimalTest = `
<!DOCTYPE html>
<html>
<head>
    <title>Minimal Button Test</title>
</head>
<body>
    <h1>Minimal Button Test</h1>
    
    <button onclick="testFunction()" style="padding: 20px; background: blue; color: white; font-size: 18px;">
        Click Me - Should Alert "SUCCESS"
    </button>
    
    <script>
        function testFunction() {
            alert('SUCCESS: Button clicked and function executed correctly!');
            console.log('SUCCESS: Function executed without issues');
        }
        
        // Test if basic JavaScript works
        console.log('Minimal test page loaded - JavaScript is working');
    </script>
</body>
</html>
`;

fs.writeFileSync('minimal-test.html', minimalTest);
console.log('✅ Created minimal-test.html');
console.log('\n📋 TESTING INSTRUCTIONS:');
console.log('1. Go to http://localhost:3000/minimal-test.html');
console.log('2. Click the blue button');
console.log('3. If you get "SUCCESS" alert, JavaScript is working');
console.log('4. If not, there\'s a fundamental JavaScript issue');

console.log('\n🎯 THIS WILL HELP ISOLATE WHETHER THE ISSUE IS:');
console.log('- JavaScript not working at all (minimal test fails)');
console.log('- Specific to the main application (minimal test works, main app fails)');
console.log('- Browser caching (hard refresh should fix it)');
console.log('- Code conflict in the main application');