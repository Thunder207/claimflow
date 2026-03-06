/**
 * Simple verification script to check if draft editing feature is deployed correctly
 * Run: node verify-draft-editing.js
 */

const https = require('https');
const fs = require('fs');

const APP_URL = 'https://claimflow-e0za.onrender.com/employee-dashboard.html';

console.log('🔍 Verifying Draft Editing Feature Deployment...\n');

// Test 1: Check if the employee dashboard loads
https.get(APP_URL, (res) => {
    console.log(`✅ App accessible: ${res.statusCode} ${res.statusMessage}`);
    
    let data = '';
    res.on('data', chunk => data += chunk);
    res.on('end', () => {
        
        // Test 2: Check if edit functionality code is present
        const hasEditingIndex = data.includes('let editingDraftIndex = -1');
        const hasEditDraftFunction = data.includes('function editDraft(index)');
        const hasRenderEditForm = data.includes('function renderDraftEditForm');
        const hasSaveDraftChanges = data.includes('function saveDraftChanges');
        const hasEditButton = data.includes('✏️ Edit');
        
        console.log(`${hasEditingIndex ? '✅' : '❌'} Edit state tracking: ${hasEditingIndex}`);
        console.log(`${hasEditDraftFunction ? '✅' : '❌'} Edit draft function: ${hasEditDraftFunction}`);
        console.log(`${hasRenderEditForm ? '✅' : '❌'} Edit form renderer: ${hasRenderEditForm}`);
        console.log(`${hasSaveDraftChanges ? '✅' : '❌'} Save changes function: ${hasSaveDraftChanges}`);
        console.log(`${hasEditButton ? '✅' : '❌'} Edit button in UI: ${hasEditButton}`);
        
        // Test 3: Check for all new editing functions
        const editFunctions = [
            'renderDraftEditForm',
            'editDraft',
            'cancelDraftEdit', 
            'saveDraftChanges',
            'addItemInEdit',
            'removeItemInEdit',
            'handleCategoryChangeInEdit',
            'updateKilometricAmount',
            'addReceiptInEdit',
            'replaceReceiptInEdit',
            'removeReceiptInEdit'
        ];
        
        console.log('\n📋 New Functions Status:');
        let allFunctionsPresent = true;
        editFunctions.forEach(func => {
            const present = data.includes(`function ${func}`);
            console.log(`${present ? '✅' : '❌'} ${func}: ${present}`);
            if (!present) allFunctionsPresent = false;
        });
        
        // Test 4: Check for button state management
        const hasButtonDisabling = data.includes('submitBtn.disabled = true') && 
                                  data.includes('editingDraftIndex !== -1');
        console.log(`\n${hasButtonDisabling ? '✅' : '❌'} Button state management: ${hasButtonDisabling}`);
        
        // Final result
        const overallSuccess = hasEditingIndex && hasEditDraftFunction && hasRenderEditForm && 
                             hasSaveDraftChanges && hasEditButton && allFunctionsPresent && 
                             hasButtonDisabling;
        
        console.log('\n' + '='.repeat(50));
        if (overallSuccess) {
            console.log('🎉 SUCCESS: Draft Editing Feature Successfully Deployed!');
            console.log('✅ All required code is present in the deployed application');
            console.log('✅ Ready for user testing');
        } else {
            console.log('❌ FAILURE: Some components missing from deployment');
            console.log('🔧 Review deployment logs and retry');
        }
        console.log('='.repeat(50));
        
        // Save verification log
        const timestamp = new Date().toISOString();
        const logContent = `Draft Editing Verification - ${timestamp}\n${overallSuccess ? 'SUCCESS' : 'FAILURE'}\n\nChecks performed:\n${editFunctions.map(f => `- ${f}: ${data.includes('function ' + f) ? 'PRESENT' : 'MISSING'}`).join('\n')}\n\nDeployment URL: ${APP_URL}\n`;
        
        fs.writeFileSync('verification-log.txt', logContent);
        console.log('\n📝 Verification log saved to: verification-log.txt');
    });
}).on('error', (err) => {
    console.log('❌ Failed to connect to app:', err.message);
});