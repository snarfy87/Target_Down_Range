extends Node

var player_profile = {
	"level": 1,
	"credits": 0,
	"total_wins": 0,
	"rank_points": 0,
	"unlocked_weapons": ["m16a4"],
	"inventory": []
}

# League Tiers & Earnings
const LEAGUES = {
	"RECRUIT": {"min_rp": 0, "win_pay": 200, "loss_pay": 100, "target_val": 5},
	"MARKSMAN": {"min_rp": 500, "win_pay": 400, "loss_pay": 200, "target_val": 10},
	"SHARPSHOOTER": {"min_rp": 1500, "win_pay": 800, "loss_pay": 400, "target_val": 20},
	"EXPERT": {"min_rp": 3000, "win_pay": 1500, "loss_pay": 750, "target_val": 35},
	"MASTER_GUNNER": {"min_rp": 5000, "win_pay": 3000, "loss_pay": 1500, "target_val": 50}
}

func get_current_league() -> Dictionary:
	var rp = player_profile.rank_points
	if rp >= 5000: return LEAGUES.MASTER_GUNNER
	elif rp >= 3000: return LEAGUES.EXPERT
	elif rp >= 1500: return LEAGUES.SHARPSHOOTER
	elif rp >= 500: return LEAGUES.MARKSMAN
	else: return LEAGUES.RECRUIT

func process_match_payout(is_winner: bool, targets_hit: int) -> Dictionary:
	var league = get_current_league()
	var base_pay = league.win_pay if is_winner else league.loss_pay
	var target_earnings = targets_hit * league.target_val
	var total_earned = base_pay + target_earnings
	
	# Update player stats
	player_profile.credits += total_earned
	var rp_change = 50 if is_winner else -25
	player_profile.rank_points = max(0, player_profile.rank_points + rp_change)
	if is_winner:
		player_profile.total_wins += 1
		
	return {"earned": total_earned, "rp_change": rp_change}
