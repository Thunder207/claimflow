const axios = require('axios');
const FormData = require('form-data');

const BASE_URL = 'http://localhost:3000';

// NJC rates
const RATES = {
  breakfast: 23.45,
  lunch: 29.75,
  dinner: 47.05,
  incidentals: 32.08,
  vehicle_per_km: 0.68
};

// Canadian cities for destinations
const CITIES = ['Ottawa', 'Toronto', 'Montreal', 'Vancouver', 'Calgary', 'Halifax', 'Winnipeg'];

// Trip purposes
const PURPOSES = [
  'Client meeting',
  'Training conference', 
  'Site inspection',
  'Team building',
  'Industry conference',
  'Sales presentation',
  'Project kickoff',
  'Vendor meeting',
  'Audit review'
];

// Valid expense types based on the API
const EXPENSE_TYPES = ['breakfast', 'lunch', 'dinner', 'incidentals', 'vehicle_km', 'hotel', 'other'];

// Employees data (using existing from database)
const employees = [
  {id: 1, name: 'John Smith', email: 'john.smith@company.com', password: 'manager123', department: 'Finance', role: 'admin'},
  {id: 2, name: 'Sarah Johnson', email: 'sarah.johnson@company.com', password: 'sarah123', department: 'Finance', role: 'supervisor'},
  {id: 3, name: 'Mike Davis', email: 'mike.davis@company.com', password: 'mike123', department: 'Finance', role: 'employee'},
  {id: 4, name: 'Lisa Brown', email: 'lisa.brown@company.com', password: 'lisa123', department: 'Operations', role: 'supervisor'},
  {id: 5, name: 'David Wilson', email: 'david.wilson@company.com', password: 'david123', department: 'Operations', role: 'employee'},
  {id: 6, name: 'Anna Lee', email: 'anna.lee@company.com', password: 'anna123', department: 'Operations', role: 'employee'},
  {id: 186, name: 'Rachel Chen', email: 'rachel.chen@company.com', password: 'rachel123', department: 'Engineering', role: 'supervisor'},
  {id: 187, name: 'Marcus Thompson', email: 'marcus.thompson@company.com', password: 'marcus123', department: 'Marketing', role: 'supervisor'},
  {id: 188, name: 'Priya Patel', email: 'priya.patel@company.com', password: 'priya123', department: 'Finance', role: 'supervisor'},
  {id: 189, name: 'James Carter', email: 'james.carter@company.com', password: 'james123', department: 'Engineering', role: 'employee'},
  {id: 190, name: 'Emily Zhang', email: 'emily.zhang@company.com', password: 'emily123', department: 'Engineering', role: 'employee'},
  {id: 191, name: 'Omar Hassan', email: 'omar.hassan@company.com', password: 'omar123', department: 'Engineering', role: 'employee'},
  {id: 192, name: 'Sophie Martin', email: 'sophie.martin@company.com', password: 'sophie123', department: 'Marketing', role: 'employee'},
  {id: 193, name: 'Tyler Brooks', email: 'tyler.brooks@company.com', password: 'tyler123', department: 'Marketing', role: 'employee'},
  {id: 194, name: 'Nina Kowalski', email: 'nina.kowalski@company.com', password: 'nina123', department: 'Marketing', role: 'employee'},
  {id: 195, name: 'Alex Rivera', email: 'alex.rivera@company.com', password: 'alex123', department: 'Finance', role: 'employee'},
  {id: 196, name: 'Fatima Al-Rashid', email: 'fatima.alrashid@company.com', password: 'fatima123', department: 'Finance', role: 'employee'}, // Fixed email
  {id: 197, name: 'Ben O\'Connor', email: 'ben.oconnor@company.com', password: 'ben123', department: 'Finance', role: 'employee'},
  {id: 198, name: 'Diana Reyes', email: 'diana.reyes@company.com', password: 'diana123', department: 'Operations', role: 'employee'}
];

// Helper functions
function getRandomItem(array) {
  return array[Math.floor(Math.random() * array.length)];
}

function getRandomDate(start, end) {
  return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
}

function formatDate(date) {
  return date.toISOString().split('T')[0];
}

function addDays(date, days) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

// Add a small random delay between API calls to avoid overwhelming the server
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Login function
async function login(email, password) {
  try {
    const response = await axios.post(`${BASE_URL}/api/auth/login`, {
      email,
      password
    });
    return response.data.success ? response.data.sessionId : null;
  } catch (error) {
    console.error(`Login failed for ${email}:`, error.response?.data || error.message);
    return null;
  }
}

// Create trip function
async function createTrip(sessionId, tripData) {
  try {
    const response = await axios.post(`${BASE_URL}/api/trips`, tripData, {
      headers: {
        'Authorization': `Bearer ${sessionId}`,
        'Content-Type': 'application/json'
      }
    });
    return response.data.success ? {id: response.data.id, ...tripData} : null;
  } catch (error) {
    console.error('Trip creation failed:', error.response?.data || error.message);
    return null;
  }
}

// Create expense function
async function createExpense(sessionId, expenseData) {
  try {
    const formData = new FormData();
    
    // Add all expense fields to form data
    Object.keys(expenseData).forEach(key => {
      if (expenseData[key] !== null && expenseData[key] !== undefined) {
        formData.append(key, expenseData[key]);
      }
    });

    const response = await axios.post(`${BASE_URL}/api/expenses`, formData, {
      headers: {
        'Authorization': `Bearer ${sessionId}`,
        ...formData.getHeaders()
      }
    });
    
    return response.data.success ? {id: response.data.id, ...expenseData} : null;
  } catch (error) {
    console.error('Expense creation failed:', error.response?.data || error.message);
    return null;
  }
}

// Submit trip function
async function submitTrip(sessionId, tripId) {
  try {
    const response = await axios.post(`${BASE_URL}/api/trips/${tripId}/submit`, {}, {
      headers: {
        'Authorization': `Bearer ${sessionId}`
      }
    });
    return response.data.success;
  } catch (error) {
    console.error('Trip submission failed:', error.response?.data || error.message);
    return false;
  }
}

// Approve expense function
async function approveExpense(sessionId, expenseId) {
  try {
    const response = await axios.post(`${BASE_URL}/api/expenses/${expenseId}/approve`, {}, {
      headers: {
        'Authorization': `Bearer ${sessionId}`
      }
    });
    return response.data.success;
  } catch (error) {
    console.error('Expense approval failed:', error.response?.data || error.message);
    return false;
  }
}

// Reject expense function
async function rejectExpense(sessionId, expenseId, reason) {
  try {
    const response = await axios.post(`${BASE_URL}/api/expenses/${expenseId}/reject`, {
      reason
    }, {
      headers: {
        'Authorization': `Bearer ${sessionId}`
      }
    });
    return response.data.success;
  } catch (error) {
    console.error('Expense rejection failed:', error.response?.data || error.message);
    return false;
  }
}

// Generate expense data
function generateExpense(tripId, tripStartDate, tripEndDate, destination) {
  const expenseType = getRandomItem(EXPENSE_TYPES);
  const expenseDate = getRandomDate(tripStartDate, tripEndDate);
  
  let amount, description, location, vendor;
  
  switch (expenseType) {
    case 'breakfast':
      amount = RATES.breakfast;
      description = `Breakfast in ${destination}`;
      location = destination;
      vendor = getRandomItem(['Hotel Restaurant', 'Tim Hortons', 'Starbucks', 'Local Cafe']);
      break;
    case 'lunch':
      amount = RATES.lunch;
      description = `Business lunch in ${destination}`;
      location = destination;
      vendor = getRandomItem(['Restaurant', 'Business Centre', 'Conference Catering', 'Local Restaurant']);
      break;
    case 'dinner':
      amount = RATES.dinner;
      description = `Business dinner in ${destination}`;
      location = destination;
      vendor = getRandomItem(['Fine Dining', 'Hotel Restaurant', 'Client Dinner Venue', 'Conference Dinner']);
      break;
    case 'hotel':
      amount = Math.floor(Math.random() * 200) + 100; // $100-300
      description = `Hotel accommodation in ${destination}`;
      location = destination;
      vendor = getRandomItem(['Marriott', 'Hilton', 'Best Western', 'Holiday Inn', 'Fairmont']);
      break;
    case 'vehicle_km':
      const km = Math.floor(Math.random() * 500) + 50; // 50-550 km
      amount = km * RATES.vehicle_per_km;
      description = `Vehicle travel - ${km} km`;
      location = `To/from ${destination}`;
      vendor = 'Personal Vehicle';
      break;
    case 'incidentals':
      amount = RATES.incidentals;
      description = `Incidental expenses in ${destination}`;
      location = destination;
      vendor = getRandomItem(['Various', 'Taxi', 'Airport', 'Local Transit']);
      break;
    case 'other':
      amount = Math.floor(Math.random() * 100) + 20; // $20-120
      description = `Conference materials and supplies`;
      location = destination;
      vendor = 'Conference Supplier';
      break;
  }
  
  return {
    trip_id: tripId,
    expense_type: expenseType,
    date: formatDate(expenseDate),
    amount: Math.round(amount * 100) / 100, // Round to 2 decimals
    description,
    location,
    vendor
  };
}

// Main function to generate demo data
async function generateDemoData() {
  console.log('🚀 Starting comprehensive demo data generation...');
  
  const createdTrips = [];
  const createdExpenses = [];
  const submittedTrips = [];
  const approvedExpenses = [];
  const rejectedExpenses = [];
  
  console.log(`📊 Processing ${employees.length} employees...`);
  
  // Create trips and expenses for each employee
  for (const employee of employees) {
    console.log(`\n👤 Processing ${employee.name} (${employee.role})...`);
    
    const sessionId = await login(employee.email, employee.password);
    if (!sessionId) {
      console.log(`   ❌ Login failed for ${employee.email}`);
      continue;
    }
    
    // Create 1-2 trips per employee
    const numTrips = Math.random() > 0.4 ? 2 : 1;
    
    for (let i = 0; i < numTrips; i++) {
      const destination = getRandomItem(CITIES);
      const purpose = getRandomItem(PURPOSES);
      
      // Generate trip dates in Feb 2026 (spread across different weeks to avoid overlap)
      const baseDate = new Date('2026-02-01');
      baseDate.setDate(baseDate.getDate() + Math.floor(Math.random() * 20)); // Random start within first 20 days
      const startDate = baseDate;
      const endDate = addDays(startDate, Math.floor(Math.random() * 4) + 1); // 1-4 days
      
      const tripData = {
        trip_name: `${destination} - ${purpose}`,
        start_date: formatDate(startDate),
        end_date: formatDate(endDate),
        destination,
        purpose
      };
      
      const trip = await createTrip(sessionId, tripData);
      if (!trip) {
        console.log(`   ❌ Failed to create trip: ${tripData.trip_name}`);
        continue;
      }
      
      console.log(`   ✅ Created trip: ${trip.trip_name} (${trip.start_date} to ${trip.end_date})`);
      createdTrips.push({...trip, employee: employee.name, employeeId: employee.id});
      
      await delay(100); // Small delay between operations
      
      // Create 2-4 expenses per trip
      const numExpenses = Math.floor(Math.random() * 3) + 2;
      
      for (let j = 0; j < numExpenses; j++) {
        const expenseData = generateExpense(trip.id, startDate, endDate, destination);
        
        const expense = await createExpense(sessionId, expenseData);
        if (expense) {
          console.log(`     💰 Created expense: ${expense.expense_type} - $${expense.amount}`);
          createdExpenses.push({...expense, employee: employee.name, employeeId: employee.id});
        } else {
          console.log(`     ❌ Failed to create expense: ${expenseData.expense_type}`);
        }
        
        await delay(50);
      }
      
      // Submit 70% of trips for approval
      if (Math.random() > 0.3) {
        const submitted = await submitTrip(sessionId, trip.id);
        if (submitted) {
          console.log(`   📤 Submitted trip for approval`);
          submittedTrips.push({...trip, employee: employee.name, employeeId: employee.id});
        }
        await delay(50);
      }
    }
    
    await delay(200); // Delay between employees
  }
  
  console.log('\n=== 👨‍💼 SUPERVISOR APPROVAL PROCESS ===');
  
  // Get supervisors for approval process
  const supervisors = employees.filter(emp => emp.role === 'supervisor' || emp.role === 'admin');
  console.log(`Found ${supervisors.length} supervisors for approval process`);
  
  // Process approvals with each supervisor
  for (const supervisor of supervisors) {
    console.log(`\n🔍 Processing approvals as ${supervisor.name} (${supervisor.role})...`);
    
    const sessionId = await login(supervisor.email, supervisor.password);
    if (!sessionId) continue;
    
    // Approve/reject expenses from their department or subordinates
    const expensesToReview = createdExpenses.filter(expense => {
      // Supervisors review their department, admins review all
      return supervisor.role === 'admin' || 
             employees.find(emp => emp.id === expense.employeeId)?.department === supervisor.department;
    });
    
    console.log(`   📋 Reviewing ${expensesToReview.length} expenses...`);
    
    for (const expense of expensesToReview) {
      const rand = Math.random();
      
      if (rand > 0.25) { // 75% approval rate
        const approved = await approveExpense(sessionId, expense.id);
        if (approved) {
          console.log(`   ✅ Approved: ${expense.expense_type} ($${expense.amount}) by ${expense.employee}`);
          approvedExpenses.push(expense);
        }
      } else if (rand < 0.1) { // 10% rejection rate
        const reasons = [
          'Receipt required for validation',
          'Amount exceeds policy limits', 
          'Missing business justification',
          'Duplicate expense detected',
          'Insufficient documentation provided'
        ];
        const rejected = await rejectExpense(sessionId, expense.id, getRandomItem(reasons));
        if (rejected) {
          console.log(`   ❌ Rejected: ${expense.expense_type} ($${expense.amount}) by ${expense.employee}`);
          rejectedExpenses.push(expense);
        }
      }
      // Remaining 15% left as pending
      
      await delay(25); // Small delay between approvals
    }
  }
  
  console.log('\n=== 📊 DEMO DATA GENERATION COMPLETE ===');
  console.log(`✅ Created ${createdTrips.length} trips`);
  console.log(`✅ Created ${createdExpenses.length} expenses`);
  console.log(`✅ Submitted ${submittedTrips.length} trips for approval`);
  console.log(`✅ Approved ${approvedExpenses.length} expenses`);
  console.log(`✅ Rejected ${rejectedExpenses.length} expenses`);
  console.log(`⏳ ${createdExpenses.length - approvedExpenses.length - rejectedExpenses.length} expenses pending review`);
  
  return {
    trips: createdTrips,
    expenses: createdExpenses,
    submittedTrips,
    approvedExpenses,
    rejectedExpenses,
    stats: {
      totalTrips: createdTrips.length,
      totalExpenses: createdExpenses.length,
      submittedTrips: submittedTrips.length,
      approvedExpenses: approvedExpenses.length,
      rejectedExpenses: rejectedExpenses.length,
      pendingExpenses: createdExpenses.length - approvedExpenses.length - rejectedExpenses.length
    }
  };
}

// Run the script
generateDemoData().then(data => {
  console.log('\n🎉 Demo data generation completed successfully!');
  process.exit(0);
}).catch(error => {
  console.error('\n💥 Demo data generation failed:', error);
  process.exit(1);
});