#!/usr/bin/env node

/**
 * 🔧 VERIFICATION: Individual Expense Draft System Fix
 * Tests if the addIndividualExpense() function correctly uses draft system
 */

const fs = require('fs');

console.log('🔧 VERIFYING INDIVIDUAL EXPENSE FIX');
console.log('==================================');

// Check 1: Verify button calls correct function
console.log('\n1️⃣ Checking button onclick...');
const htmlContent = fs.readFileSync('./employee-dashboard.html', 'utf8');

if (htmlContent.includes('onclick="addIndividualExpense()"')) {
    console.log('✅ Button correctly calls addIndividualExpense()');
} else {
    console.log('❌ Button does not call addIndividualExpense()');
}

// Check 2: Verify function exists and uses draft system
console.log('\n2️⃣ Checking function implementation...');

if (htmlContent.includes('function addIndividualExpense()')) {
    console.log('✅ addIndividualExpense() function exists');
    
    // Check if it adds to draft array
    if (htmlContent.includes('draftIndividualExpenses.push(expense)')) {
        console.log('✅ Function adds expense to draft array');
    } else {
        console.log('❌ Function does not add to draft array');
    }
    
    // Check if it makes API calls (more precise check)
    const functionMatch = htmlContent.match(/function addIndividualExpense\(\)[\s\S]*?(?=function |$)/);
    if (functionMatch) {
        const functionBody = functionMatch[0];
        if (functionBody.includes('fetch(') && functionBody.includes('/api/expenses')) {
            console.log('❌ Function makes direct API calls (WRONG!)');
            console.log('   Found API call in function body');
        } else {
            console.log('✅ Function does not make direct API calls');
        }
    } else {
        console.log('❌ Could not extract function body for analysis');
    }
} else {
    console.log('❌ addIndividualExpense() function not found');
}

// Check 3: Verify debugging was added
console.log('\n3️⃣ Checking debugging additions...');

if (htmlContent.includes('DEBUG: Individual expense button clicked')) {
    console.log('✅ Debug alerts added for testing');
} else {
    console.log('❌ Debug alerts not added');
}

// Check 4: Verify draft submission function exists
console.log('\n4️⃣ Checking batch submission function...');

if (htmlContent.includes('function submitIndividualExpensesForApproval()')) {
    console.log('✅ Batch submission function exists');
    
    // Check if it loops through drafts
    if (htmlContent.includes('for (const expense of draftIndividualExpenses)')) {
        console.log('✅ Batch submission loops through draft array');
    } else {
        console.log('❌ Batch submission does not loop through drafts');
    }
} else {
    console.log('❌ Batch submission function not found');
}

// Check 5: Verify draft display function
console.log('\n5️⃣ Checking draft display function...');

if (htmlContent.includes('function updateDraftIndividualList()')) {
    console.log('✅ Draft display function exists');
    
    if (htmlContent.includes('draftIndividualExpenses.length')) {
        console.log('✅ Display function uses draft array length');
    } else {
        console.log('❌ Display function does not check draft array');
    }
} else {
    console.log('❌ Draft display function not found');
}

console.log('\n🎯 VERIFICATION SUMMARY:');
console.log('========================');

// Analyze the workflow
let workflowCorrect = true;
let issues = [];

// Check for draft workflow
const hasDraftPush = htmlContent.includes('draftIndividualExpenses.push(expense)');
const hasDraftSubmission = htmlContent.includes('for (const expense of draftIndividualExpenses)');

// More accurate API call check
const functionMatch = htmlContent.match(/function addIndividualExpense\(\)[\s\S]*?(?=function |$)/);
let hasDirectAPI = false;
if (functionMatch) {
    const functionBody = functionMatch[0];
    hasDirectAPI = functionBody.includes('fetch(') && functionBody.includes('/api/expenses');
}

if (hasDraftPush && hasDraftSubmission && !hasDirectAPI) {
    console.log('✅ WORKFLOW APPEARS CORRECT: Draft system implementation found');
} else {
    console.log('❌ WORKFLOW ISSUES DETECTED:');
    if (!hasDraftPush) {
        issues.push('- addIndividualExpense() does not add to draft array');
    }
    if (!hasDraftSubmission) {
        issues.push('- No batch submission of draft expenses');  
    }
    if (hasDirectAPI) {
        issues.push('- addIndividualExpense() makes direct API calls');
    }
    issues.forEach(issue => console.log(issue));
    workflowCorrect = false;
}

console.log('\n📋 MANUAL TESTING INSTRUCTIONS:');
console.log('===============================');
console.log('1. Go to: http://localhost:3000');
console.log('2. Login: david.wilson@company.com / david123');
console.log('3. Fill expense form (leave trip dropdown as "No trip")');
console.log('4. Click blue "💰 Add Individual Expense" button');
console.log('5. EXPECTED: Alert shows "DEBUG: Individual expense button clicked"');
console.log('6. EXPECTED: Second alert shows "SUCCESS: Added to DRAFT only!"');
console.log('7. EXPECTED: Blue section shows expense in draft list');
console.log('8. Repeat steps 3-6 to add more expenses');
console.log('9. Click "Submit All Individual Expenses" to submit batch');

console.log('\n🚨 KEY TEST:');
console.log('If you see TWO alert popups when clicking the blue button,');
console.log('the function is working correctly and only adding to draft!');

console.log('\n⚡ SERVER STATUS: ' + (workflowCorrect ? 'READY FOR TESTING' : 'NEEDS FIXES'));

if (workflowCorrect) {
    console.log('🎉 Individual expense draft system should now work correctly!');
} else {
    console.log('❌ Additional fixes needed before testing');
}