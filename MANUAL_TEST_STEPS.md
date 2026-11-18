# Manual Verification Steps for Workout Logger UI

## Browser Reload Recovery Test

### Setup
```bash
cd /c/Users/neyma/OneDrive/Desktop/gym_workout_tracker_v2
flutter run -d chrome
```

### Test Steps

1. **Start Workout**
   - Click "Start Workout" button
   - Verify: Active workout editor appears with app bar showing "Active Workout"

2. **Add Exercise**
   - Enter "Bench Press" in exercise name field
   - Click "Add" button
   - Verify: Exercise card appears with "Bench Press" title

3. **Add Sets**
   - Click "+ Add Set" on Bench Press card
   - Enter reps: 10
   - Enter weight: 60
   - Click "+ Add Set" again
   - Enter reps: 8
   - Enter weight: 65
   - Verify: Two sets show with correct values

4. **Add Second Exercise**
   - Enter "Squat" in exercise name field
   - Click "Add"
   - Add set: reps 12, weight 80
   - Verify: Two exercises visible with sets

5. **Browser Reload (Critical)**
   - Press F5 or Ctrl+R to reload page
   - Wait for app to initialize
   - **Expected**: Active workout editor reappears with both exercises and all sets preserved
   - **Verify**: All reps and weight values match pre-reload state

6. **Finish Workout**
   - Click checkmark icon in app bar
   - Verify: "Workout saved" snackbar appears
   - Verify: Returns to workout list showing new workout

7. **View History**
   - Verify: New workout appears in history with date, exercise count, duration
   - Click workout card
   - Verify: Detail screen shows all exercises and sets read-only

8. **Discard Test**
   - Click "Start Workout"
   - Add exercise "Test Exercise"
   - Click X icon in app bar
   - Verify: Confirmation dialog appears
   - Click "Discard"
   - Verify: Returns to workout list
   - Verify: Test Exercise not saved

## Expected Results

✅ Active workout survives browser reload
✅ All exercises and sets persist
✅ Field values preserved (reps, weight, set type)
✅ Finish workflow completes without errors
✅ History displays correctly
✅ Detail view shows read-only data
✅ Discard confirmation prevents accidental loss

## Known Limitations

- Widget tests require provider overrides for database isolation
- UI tests in test suite need async provider mocking (deferred)
- Manual testing required for full workflow verification
