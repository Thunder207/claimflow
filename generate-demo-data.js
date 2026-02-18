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

// Employees data
const employees = [
  {id: 1, name: 'John Smith', email: 'john.smith@company.com', password: 'john123', department: 'Finance', role: 'admin'},
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
  {id: 196, name: 'Fatima Al-Rashid', email: 'fatima.al-rashid@company.com', password: 'fatima123', department: 'Finance', role: 'employee'},
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

// Login function
async function login(email, password) {
  try {
    const response = await axios.post(`${BASE_URL}/api/auth/login`, {
      email,
      password
    });
    return response.data.sessionId;
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
    return response.data;
  } catch (error) {
    console.error('Trip creation failed:', error.response?.data || error.message);
    return null;
  }
}

// Create expense function
async function createExpense(sessionId, tripId, expenseData) {
  try {
    const formData = new FormData();
    Object.keys(expenseData).forEach(key => {
      formData.append(key, expenseData[key]);
    });

    const response = await axios.post(`${BASE_URL}/api/expenses`, formData, {
      headers: {
        'Authorization': `Bearer ${sessionId}`,
        ...formData.getHeaders()
      }
    });
    return response.data;
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
    return response.data;
  } catch (error) {
    console.error('Trip submission failed:', error.response?.data || error.message);
    return null;
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
    return response.data;
  } catch (error) {
    console.error('Expense approval failed:', error.response?.data || error.message);
    return null;
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
    return response.data;
  } catch (error) {
    console.error('Expense rejection failed:', error.response?.data || error.message);
    return null;
  }
}

// Generate expense data
function generateExpense(tripStartDate, tripEndDate, destination) {
  const expenseTypes = ['breakfast', 'lunch', 'dinner', 'hotel', 'vehicle', 'incidentals'];
  const expenseType = getRandomItem(expenseTypes);
  
  const expenseDate = getRandomDate(tripStartDate, tripEndDate);
  
  let amount, description;
  
  switch (expenseType) {
    case 'breakfast':
      amount = RATES.breakfast;
      description = `Breakfast in ${destination}`;
      break;
    case 'lunch':
      amount = RATES.lunch;
      description = `Lunch meeting in ${destination}`;
      break;
    case 'dinner':
      amount = RATES.dinner;
      description = `Business dinner in ${destination}`;
      break;
    case 'hotel':
      amount = Math.floor(Math.random() * 200) + 100; // $100-300
      description = `Hotel accommodation in ${destination}`;
      break;
    case 'vehicle':
      const km = Math.floor(Math.random() * 500) + 50; // 50-550 km
      amount = km * RATES.vehicle_per_km;
      description = `Vehicle travel - ${km} km`;
      break;
    case 'incidentals':
      amount = RATES.incidentals;
      description = `Incidental expenses in ${destination}`;
      break;
  }
  
  return {
    description,
    amount: Math.round(amount * 100) / 100, // Round to 2 decimals
    date: formatDate(expenseDate),
    category: expenseType
  };
}

// Main function to generate demo data
async function generateDemoData() {
  console.log('Starting demo data generation...');
  
  const createdTrips = [];
  const createdExpenses = [];
  const submittedTrips = [];
  
  // Create trips and expenses for each employee
  for (const employee of employees) {
    console.log(`\nProcessing ${employee.name}...`);
    
    const sessionId = await login(employee.email, employee.password);
    if (!sessionId) continue;
    
    // Create 1-2 trips per employee
    const numTrips = Math.random() > 0.3 ? 2 : 1;
    
    for (let i = 0; i < numTrips; i++) {
      const destination = getRandomItem(CITIES);
      const purpose = getRandomItem(PURPOSES);
      
      // Generate trip dates in Feb 2026
      const startDate = getRandomDate(new Date('2026-02-01'), new Date('2026-02-25'));
      const endDate = addDays(startDate, Math.floor(Math.random() * 5) + 1); // 1-5 days
      
      const tripData = {
        trip_name: `${destination} ${purpose}`,
        start_date: formatDate(startDate),
        end_date: formatDate(endDate),
        destination,
        purpose
      };
      
      const trip = await createTrip(sessionId, tripData);
      if (!trip) continue;
      
      console.log(`  Created trip: ${trip.trip_name}`);
      createdTrips.push({...trip, employee: employee.name});
      
      // Create 2-4 expenses per trip
      const numExpenses = Math.floor(Math.random() * 3) + 2;
      
      for (let j = 0; j < numExpenses; j++) {
        const expenseData = generateExpense(startDate, endDate, destination);
        expenseData.trip_id = trip.id;
        
        const expense = await createExpense(sessionId, trip.id, expenseData);
        if (expense) {
          console.log(`    Created expense: ${expense.description} - $${expense.amount}`);
          createdExpenses.push({...expense, employee: employee.name});
        }
      }
      
      // Submit 70% of trips
      if (Math.random() > 0.3) {
        const submitted = await submitTrip(sessionId, trip.id);
        if (submitted) {
          console.log(`    Submitted trip for approval`);
          submittedTrips.push({...trip, employee: employee.name});
        }
      }
      
      // Small delay between operations
      await new Promise(resolve => setTimeout(resolve, 100));
    }
  }
  
  console.log('\n=== SUPERVISOR APPROVALS ===');
  
  // Get supervisors for approval process
  const supervisors = employees.filter(emp => emp.role === 'supervisor' || emp.role === 'admin');
  
  // Get all expenses that need review (from submitted trips)
  for (const supervisor of supervisors) {
    console.log(`\nProcessing approvals as ${supervisor.name}...`);
    
    const sessionId = await login(supervisor.email, supervisor.password);
    if (!sessionId) continue;
    
    // Approve 60-70% of expenses, reject some others
    for (const expense of createdExpenses) {
      const rand = Math.random();
      
      if (rand > 0.4) { // 60% approval rate
        const approved = await approveExpense(sessionId, expense.id);
        if (approved) {
          console.log(`  Approved: ${expense.description} by ${expense.employee}`);
        }
      } else if (rand < 0.1) { // 10% rejection rate
        const reasons = [
          'Receipt required for validation',
          'Amount exceeds policy limits',
          'Missing business justification',
          'Duplicate expense detected'
        ];
        const rejected = await rejectExpense(sessionId, expense.id, getRandomItem(reasons));
        if (rejected) {
          console.log(`  Rejected: ${expense.description} by ${expense.employee}`);
        }
      }
      // Remaining 30% left as pending
      
      // Small delay
      await new Promise(resolve => setTimeout(resolve, 50));
    }
  }
  
  console.log('\n=== DEMO DATA GENERATION COMPLETE ===');
  console.log(`Created ${createdTrips.length} trips`);
  console.log(`Created ${createdExpenses.length} expenses`);
  console.log(`Submitted ${submittedTrips.length} trips for approval`);
  
  return {
    trips: createdTrips,
    expenses: createdExpenses,
    submittedTrips
  };
}

// Run the script
generateDemoData().catch(console.error);