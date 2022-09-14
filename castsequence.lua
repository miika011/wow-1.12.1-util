local MIN_CAST_INTERVAL_SECONDS = 0.1;
local sequenceLastCast = GetTime(); --Need to limit how quickly doCast(...) is run again

local Sequences = {
    
    doCast = function(sequence)
        assert(getn(sequence.spellSequence) >= 1);
        if sequence.index > getn(sequence.spellSequence) then
            sequence.index = 1;
        end
        local spellToCast = sequence.spellSequence[sequence.index];
        local now = GetTime();
        if now - sequenceLastCast >= MIN_CAST_INTERVAL_SECONDS and not SpellIsOnCooldown(spellToCast) then
            sequenceLastCast = now;
            CastSpellByName(sequence.spellSequence[sequence.index]);
            sequence.index = sequence.index + 1;
        else
            print(spellToCast .. " is on cooldown.");
        end
    end
};


function castSequence(commaSeparatedArgs)
    spells = string.split(commaSeparatedArgs, ",");
    for i = 1, getn(spells) do
        spells[i] = string.strip(spells[i]);
    end
    local JOIN_TOKEN = "->";
    local sequenceStr = string.join(JOIN_TOKEN, spells);
    sequence = Sequences[sequenceStr] or {index = 1, spellSequence = spells};
    Sequences[sequenceStr] = sequence;
    
    Sequences.doCast(sequence);
end



SLASH_CASTSEQUENCE1 = "/castsequence";
SlashCmdList["CASTSEQUENCE"] = castSequence;
