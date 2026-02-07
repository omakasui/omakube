# Place in ~/.claude/skills since all tools populate from there as well as their own sources
mkdir -p ~/.claude/skills
if [ -d "$OMAKUB_PATH/default/omakub-ai-skill" ]; then
    rm -rf ~/.claude/skills/omakub-ai
fi
ln -s $OMAKUB_PATH/default/omakub-ai-skill ~/.claude/skills/omakub-ai