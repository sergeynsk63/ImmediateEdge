//
//  TextLibraryService.swift
//  ImmediateEdgeApp
//
//

import Foundation
import Combine

class TextLibraryService: ObservableObject {
    static let shared = TextLibraryService()

    @Published var texts: [TextContent] = []
    @Published var filteredTexts: [TextContent] = []

    init() {
        loadTexts()
    }

    func loadTexts() {
        texts = TextLibraryData.allTexts
        filteredTexts = texts
    }

    func filterTexts(category: TextCategory? = nil, difficulty: Difficulty? = nil, searchQuery: String = "") {
        filteredTexts = texts.filter { text in
            let matchesCategory = category == nil || text.category == category
            let matchesDifficulty = difficulty == nil || text.difficulty == difficulty
            let matchesSearch = searchQuery.isEmpty ||
                text.title.localizedCaseInsensitiveContains(searchQuery) ||
                text.content.localizedCaseInsensitiveContains(searchQuery)

            return matchesCategory && matchesDifficulty && matchesSearch
        }
    }

    func getText(by id: String) -> TextContent? {
        texts.first { $0.id == id }
    }
}

// MARK: - Text Library Data
struct TextLibraryData {
    static let allTexts: [TextContent] = [
        // Business & Marketing (2 texts)
        TextContent(
            id: "biz_001",
            title: "The Future of Digital Marketing",
            category: .business,
            difficulty: .intermediate,
            wordCount: 450,
            content: """
Digital marketing has evolved dramatically over the past decade, transforming from simple banner ads and email campaigns into a sophisticated ecosystem of channels, tools, and strategies. Today's marketers must navigate social media platforms, search engine optimization, content marketing, and data analytics to reach their audiences effectively.

The rise of artificial intelligence and machine learning is revolutionizing how businesses approach marketing. These technologies enable personalized experiences at scale, predicting customer behavior and optimizing campaigns in real-time. Chatbots powered by AI can handle customer inquiries 24/7, while recommendation engines suggest products based on individual preferences and browsing history.

Social media continues to dominate the digital marketing landscape. Platforms like Instagram, TikTok, and LinkedIn have become essential tools for brand building and customer engagement. Influencer marketing has emerged as a powerful strategy, with micro-influencers often delivering better engagement rates than traditional celebrity endorsements.

However, the digital marketing world faces significant challenges. Privacy concerns and regulations like GDPR and CCPA are changing how marketers can collect and use customer data. The decline of third-party cookies is forcing companies to develop new strategies for tracking and attribution. Additionally, consumers are becoming increasingly skeptical of advertising, with ad blockers becoming more popular.

Looking ahead, successful digital marketers will need to balance personalization with privacy, create authentic connections with audiences, and stay adaptable in a rapidly changing technological landscape. The brands that thrive will be those that put customer experience at the center of their digital strategies.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "What is revolutionizing modern marketing approaches?", options: ["Social media only", "AI and machine learning", "Email campaigns", "Banner ads"], correctAnswerIndex: 1, type: .details),
                Question(question: "What challenge is mentioned regarding third-party cookies?", options: ["They are becoming more expensive", "They are being phased out", "They are too effective", "They are mandatory"], correctAnswerIndex: 1, type: .details),
                Question(question: "What is the main idea of this text?", options: ["AI will replace marketers", "Digital marketing is becoming more complex and data-driven", "Social media is the only important channel", "Marketing is getting easier"], correctAnswerIndex: 1, type: .mainIdea),
                Question(question: "According to the text, what do successful future marketers need to balance?", options: ["Cost and profit", "Personalization and privacy", "Speed and quality", "Online and offline"], correctAnswerIndex: 1, type: .details),
                Question(question: "What type of influencers often deliver better engagement?", options: ["Celebrity influencers", "Micro-influencers", "Political influencers", "Corporate influencers"], correctAnswerIndex: 1, type: .details)
            ]
        ),

        TextContent(
            id: "biz_002",
            title: "Remote Work Revolution",
            category: .business,
            difficulty: .beginner,
            wordCount: 380,
            content: """
The COVID-19 pandemic accelerated a workplace transformation that was already underway: the shift to remote work. What began as a necessity has evolved into a permanent feature of modern business operations. Companies worldwide are discovering that remote work offers benefits beyond crisis management.

Productivity has been a pleasant surprise for many organizations. Contrary to initial concerns, studies show that remote workers often accomplish more than their office-based counterparts. Without lengthy commutes and office distractions, employees can focus better and manage their time more effectively. Many report improved work-life balance and job satisfaction.

Technology has been the great enabler of this revolution. Video conferencing tools like Zoom and Microsoft Teams have made face-to-face communication possible from anywhere. Project management platforms help teams collaborate asynchronously across time zones. Cloud computing ensures that important files and applications are accessible from any location.

However, remote work isn't without challenges. Some employees struggle with isolation and miss the social aspects of office life. Managing teams remotely requires different skills from traditional management. Companies must be intentional about maintaining culture and ensuring all team members feel connected and valued.

The future of work is likely hybrid, combining the best of both worlds. Employees might split time between home and office, coming together for collaboration and staying home for focused work. This flexibility could become a key factor in attracting and retaining talent.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "What event accelerated the remote work trend?", options: ["A new technology", "The COVID-19 pandemic", "A government mandate", "An economic crisis"], correctAnswerIndex: 1, type: .details),
                Question(question: "What has been surprising about remote work productivity?", options: ["It decreased significantly", "It stayed the same", "It often increased", "It became unpredictable"], correctAnswerIndex: 2, type: .details),
                Question(question: "What is mentioned as a challenge of remote work?", options: ["Higher costs", "Too much productivity", "Employee isolation", "Technology failures"], correctAnswerIndex: 2, type: .details),
                Question(question: "What does the text suggest about the future of work?", options: ["Fully remote", "Back to office only", "Hybrid model", "Unpredictable"], correctAnswerIndex: 2, type: .inference),
                Question(question: "What role has technology played in remote work?", options: ["It created barriers", "It enabled the transition", "It was irrelevant", "It slowed progress"], correctAnswerIndex: 1, type: .details)
            ]
        ),

        // Science & Technology (2 texts)
        TextContent(
            id: "sci_001",
            title: "Quantum Computing Explained",
            category: .science,
            difficulty: .advanced,
            wordCount: 520,
            content: """
Quantum computing represents one of the most exciting frontiers in modern technology. Unlike classical computers that process information in binary bits (0s and 1s), quantum computers use quantum bits, or qubits, which can exist in multiple states simultaneously through a property called superposition.

This fundamental difference gives quantum computers extraordinary potential power. While a classical computer must examine each possible solution to a problem sequentially, a quantum computer can evaluate multiple possibilities at once. For certain types of problems, particularly those involving optimization or complex simulations, this parallel processing capability could reduce computing time from years to minutes.

The principle of quantum entanglement adds another layer of power. When qubits become entangled, the state of one qubit instantly influences the state of another, regardless of the distance between them. This phenomenon, which Einstein famously called "spooky action at a distance," enables quantum computers to process information in ways impossible for classical systems.

However, quantum computing faces significant challenges. Qubits are extremely fragile and prone to errors from environmental interference, a problem known as decoherence. Quantum computers must operate at temperatures close to absolute zero to maintain qubit stability. Current quantum computers can only maintain their quantum state for brief moments before errors accumulate.

Despite these challenges, progress is rapid. Tech giants like IBM, Google, and Microsoft are investing heavily in quantum computing research. Google claimed "quantum supremacy" in 2019 when their quantum computer solved a problem that would take classical supercomputers thousands of years.

The potential applications are transformative. Quantum computers could revolutionize drug discovery by simulating molecular interactions, optimize financial portfolios, break current encryption methods, improve artificial intelligence, and model climate change with unprecedented accuracy. As the technology matures, quantum computing may solve problems currently considered impossible.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "What property allows qubits to exist in multiple states?", options: ["Binary processing", "Superposition", "Classical computing", "Digital encoding"], correctAnswerIndex: 1, type: .vocabulary),
                Question(question: "What temperature do quantum computers need to operate?", options: ["Room temperature", "Boiling point", "Close to absolute zero", "Body temperature"], correctAnswerIndex: 2, type: .details),
                Question(question: "What is decoherence?", options: ["A computing advantage", "Quantum entanglement", "Environmental interference causing errors", "A type of qubit"], correctAnswerIndex: 2, type: .vocabulary),
                Question(question: "What did Google claim in 2019?", options: ["Quantum impossibility", "Quantum supremacy", "Quantum failure", "Quantum simplicity"], correctAnswerIndex: 1, type: .details),
                Question(question: "What is the main advantage of quantum computing?", options: ["Lower cost", "Smaller size", "Parallel processing of possibilities", "Easier programming"], correctAnswerIndex: 2, type: .mainIdea)
            ]
        ),

        TextContent(
            id: "sci_002",
            title: "Renewable Energy Technologies",
            category: .science,
            difficulty: .intermediate,
            wordCount: 440,
            content: """
The transition to renewable energy is accelerating as technology improves and costs decline. Solar and wind power, once considered expensive alternatives, are now often cheaper than fossil fuels. This shift is transforming the global energy landscape and our approach to climate change.

Solar energy technology has made remarkable strides. Modern photovoltaic panels convert sunlight to electricity with ever-increasing efficiency. Perovskite solar cells, a new technology, promise even better performance at lower costs. Solar installations are appearing everywhere from massive desert arrays to rooftop panels on homes and businesses. Energy storage solutions, particularly lithium-ion batteries, are solving the intermittency problem that once limited solar power's usefulness.

Wind energy has also matured significantly. Modern wind turbines tower hundreds of feet tall, with blade spans longer than football fields. Offshore wind farms capture stronger, more consistent winds over the ocean. Improvements in turbine design and materials have increased efficiency while reducing maintenance costs. Some countries now generate significant portions of their electricity from wind.

Hydroelectric power remains the largest source of renewable electricity globally. While large dams have environmental concerns, new technologies like run-of-river systems and tidal energy offer less disruptive alternatives. Geothermal energy taps into the Earth's heat, providing constant, reliable power in volcanically active regions.

The key challenge facing renewables is energy storage. The sun doesn't always shine, and the wind doesn't always blow. Battery technology is improving rapidly, but large-scale, long-duration storage remains expensive. Grid modernization is also essential – smart grids can balance supply and demand more effectively, integrating diverse renewable sources.

As costs continue to fall and technology improves, renewable energy is becoming not just environmentally necessary but economically advantageous. The energy transition is no longer a question of if, but how quickly it can happen.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "What has made solar and wind power more competitive?", options: ["Government mandates", "Declining costs and improving technology", "Fossil fuel shortages", "Consumer preferences"], correctAnswerIndex: 1, type: .details),
                Question(question: "What technology is helping solve solar power's intermittency problem?", options: ["Nuclear power", "Energy storage/batteries", "Coal backup", "Diesel generators"], correctAnswerIndex: 1, type: .details),
                Question(question: "What is mentioned as a key challenge for renewables?", options: ["Too much power", "Public opposition", "Energy storage", "Excessive costs"], correctAnswerIndex: 2, type: .details),
                Question(question: "What type of renewable energy is currently the largest globally?", options: ["Solar", "Wind", "Hydroelectric", "Geothermal"], correctAnswerIndex: 2, type: .details),
                Question(question: "According to the text, what makes offshore wind attractive?", options: ["Lower cost", "Easier installation", "Stronger, more consistent winds", "Less equipment needed"], correctAnswerIndex: 2, type: .details)
            ]
        ),

        // History & Culture (2 texts)
        TextContent(
            id: "hist_001",
            title: "The Renaissance: Rebirth of Knowledge",
            category: .history,
            difficulty: .intermediate,
            wordCount: 390,
            content: """
The Renaissance, spanning roughly from the 14th to 17th centuries, marked a profound transformation in European culture, art, and thought. Beginning in Italy and spreading throughout Europe, this period saw a renewed interest in classical Greek and Roman learning, combined with new innovations in art, science, and philosophy.

The movement emerged in Italian city-states like Florence, Venice, and Rome, where wealthy merchant families became patrons of the arts. The Medici family of Florence, in particular, sponsored artists and scholars, creating an environment where creativity could flourish. This patronage system allowed artists to focus on their work and push the boundaries of their crafts.

Renaissance art revolutionized visual expression. Artists like Leonardo da Vinci and Michelangelo mastered perspective, anatomy, and realistic portrayal of human emotions. The invention of linear perspective allowed artists to create the illusion of depth on flat surfaces. Sculptures became more dynamic and lifelike, breaking from the rigid forms of medieval art.

The period also witnessed the invention of the printing press by Johannes Gutenberg around 1440. This technological breakthrough democratized knowledge, making books affordable and accessible to a broader audience. Ideas could spread faster than ever before, accelerating the pace of change and learning.

The Renaissance legacy extends far beyond art. It fostered humanistic philosophy that emphasized human potential and individual achievement. Scientific inquiry became more systematic and empirical. The seeds of the Scientific Revolution and the Enlightenment were planted during this transformative era.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "Where did the Renaissance begin?", options: ["France", "England", "Italy", "Spain"], correctAnswerIndex: 2, type: .details),
                Question(question: "Who invented the printing press?", options: ["Leonardo da Vinci", "Johannes Gutenberg", "Michelangelo", "The Medici family"], correctAnswerIndex: 1, type: .details),
                Question(question: "What did the printing press accomplish?", options: ["Made art better", "Democratized knowledge", "Replaced artists", "Stopped wars"], correctAnswerIndex: 1, type: .details),
                Question(question: "What artistic technique created the illusion of depth?", options: ["Sculpture", "Linear perspective", "Patronage", "Printing"], correctAnswerIndex: 1, type: .vocabulary),
                Question(question: "What is the main idea of this text?", options: ["Art became expensive", "The Renaissance transformed European culture and learning", "Italy conquered Europe", "Knowledge became restricted"], correctAnswerIndex: 1, type: .mainIdea)
            ]
        ),

        TextContent(
            id: "hist_002",
            title: "The Space Race",
            category: .history,
            difficulty: .beginner,
            wordCount: 360,
            content: """
The Space Race was one of the most dramatic competitions of the Cold War era, pitting the United States against the Soviet Union in a contest to achieve supremacy in spaceflight capability. This technological rivalry produced some of humanity's greatest achievements beyond Earth.

The race began in 1957 when the Soviet Union successfully launched Sputnik 1, the first artificial satellite to orbit Earth. This achievement shocked Americans and sparked fears that the Soviets had gained a technological advantage. The United States responded by accelerating its own space program and establishing NASA in 1958.

Both nations achieved remarkable milestones. The Soviets sent the first human, Yuri Gagarin, into space in 1961. The Americans countered with Project Mercury, sending John Glenn to orbit Earth in 1962. Each success by one side spurred the other to attempt something even more ambitious.

The ultimate goal became landing humans on the Moon. President John F. Kennedy committed the United States to this mission in 1961, declaring they would accomplish it before the decade's end. The Apollo program was born, employing hundreds of thousands of workers and costing billions of dollars.

On July 20, 1969, Apollo 11 astronauts Neil Armstrong and Buzz Aldrin became the first humans to walk on the Moon, with Armstrong's famous words "That's one small step for man, one giant leap for mankind." The United States had won the Space Race, though both nations continued space exploration afterward.

The Space Race's legacy extends beyond geopolitical competition. It drove innovations in technology, materials science, and computer systems that benefit us today. It also inspired generations to pursue careers in science and engineering.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "What event started the Space Race?", options: ["Apollo 11 landing", "Sputnik 1 launch", "NASA creation", "First satellite"], correctAnswerIndex: 1, type: .details),
                Question(question: "Who was the first human in space?", options: ["Neil Armstrong", "John Glenn", "Yuri Gagarin", "Buzz Aldrin"], correctAnswerIndex: 2, type: .details),
                Question(question: "When did humans first walk on the Moon?", options: ["1957", "1961", "1969", "1975"], correctAnswerIndex: 2, type: .details),
                Question(question: "What organization did the US create for space exploration?", options: ["NASA", "ESA", "SpaceX", "Apollo"], correctAnswerIndex: 0, type: .details),
                Question(question: "According to the text, what was a lasting benefit of the Space Race?", options: ["Military superiority", "Technological innovations", "Political unity", "Economic equality"], correctAnswerIndex: 1, type: .inference)
            ]
        ),

        // Psychology & Personal Development (2 texts)
        TextContent(
            id: "psy_001",
            title: "The Power of Habits",
            category: .psychology,
            difficulty: .beginner,
            wordCount: 410,
            content: """
Habits shape our daily lives more than we realize. Research suggests that about 40% of our daily actions are not conscious decisions but habits – automatic behaviors performed without thinking. Understanding how habits work can help us build better ones and break destructive patterns.

The habit loop consists of three parts: a cue, a routine, and a reward. The cue triggers the behavior, the routine is the behavior itself, and the reward is what your brain gets from completing the habit. For example, feeling stressed (cue) might trigger eating comfort food (routine) which provides temporary relief (reward). Over time, this loop becomes automatic.

Building new habits requires patience and consistency. Studies show it takes an average of 66 days for a new behavior to become automatic, though this varies widely depending on the complexity of the habit and individual differences. Starting small is crucial – trying to change too much at once often leads to failure.

The concept of "habit stacking" can make building new habits easier. This involves attaching a new habit to an existing one. For instance, if you want to start meditating, you might do it right after your morning coffee – an already established habit. The existing habit serves as the cue for the new one.

Environment plays a crucial role in habit formation. Making desired behaviors easier and undesired behaviors harder can significantly impact success. Want to exercise more? Keep your workout clothes visible. Want to reduce screen time? Put your phone in another room. These environmental changes work with your brain's natural tendency toward the path of least resistance.

Breaking bad habits is challenging because the neural pathways remain even after the behavior stops. The key is not to eliminate the habit loop but to replace the routine while keeping the same cue and reward. This is why many successful smoking cessation programs focus on replacing the physical habit with something else rather than just stopping.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "What percentage of daily actions are habits?", options: ["About 20%", "About 40%", "About 60%", "About 80%"], correctAnswerIndex: 1, type: .details),
                Question(question: "How many days does it typically take to form a new habit?", options: ["21 days", "30 days", "66 days", "100 days"], correctAnswerIndex: 2, type: .details),
                Question(question: "What are the three parts of the habit loop?", options: ["Think, act, rest", "Cue, routine, reward", "Start, middle, end", "Plan, execute, evaluate"], correctAnswerIndex: 1, type: .details),
                Question(question: "What is 'habit stacking'?", options: ["Doing many habits at once", "Attaching new habits to existing ones", "Eliminating old habits", "Counting your habits"], correctAnswerIndex: 1, type: .vocabulary),
                Question(question: "According to the text, what's the best way to break bad habits?", options: ["Use willpower alone", "Replace the routine in the habit loop", "Eliminate all cues", "Ignore the problem"], correctAnswerIndex: 1, type: .inference)
            ]
        ),

        TextContent(
            id: "psy_002",
            title: "Growth Mindset vs Fixed Mindset",
            category: .psychology,
            difficulty: .intermediate,
            wordCount: 420,
            content: """
Psychologist Carol Dweck's research on mindsets has revolutionized how we understand achievement and personal development. Her work identifies two fundamental mindsets that shape how people approach challenges, learning, and failure: the fixed mindset and the growth mindset.

People with a fixed mindset believe their abilities, intelligence, and talents are static traits that cannot be significantly changed. They see challenges as threats to their self-image and tend to avoid situations where they might fail. When faced with obstacles, they're more likely to give up, believing that struggling means they lack natural ability. Criticism feels like a personal attack rather than useful feedback.

In contrast, those with a growth mindset believe abilities can be developed through dedication, hard work, and learning from mistakes. They view challenges as opportunities to grow and improve. Failure isn't a reflection of their worth but valuable feedback about what strategies need adjustment. They're more resilient because setbacks are seen as temporary and surmountable.

The implications are profound. Students with growth mindsets tend to achieve more because they worry less about looking smart and focus more on learning. In the workplace, employees with growth mindsets are more likely to take on challenging projects and persist through difficulties. They're also more open to feedback and collaboration.

Fortunately, mindsets aren't fixed themselves – they can be changed. Recognizing fixed mindset thoughts is the first step. Instead of thinking "I'm not good at this," try "I'm not good at this yet." Focus on effort and strategy rather than innate talent. Celebrate progress and learning rather than just outcomes.

Parents and educators can foster growth mindsets by praising effort, strategies, and progress rather than intelligence or talent. Instead of saying "You're so smart," try "I can see how hard you worked on this" or "Your strategy really paid off." This subtle shift in language can have lasting impacts on how children approach learning and challenges throughout their lives.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "Who developed the concept of growth and fixed mindsets?", options: ["Sigmund Freud", "Carol Dweck", "B.F. Skinner", "Albert Einstein"], correctAnswerIndex: 1, type: .details),
                Question(question: "What do people with a fixed mindset believe?", options: ["Abilities can be developed", "Intelligence is static", "Failure is valuable", "Challenges are opportunities"], correctAnswerIndex: 1, type: .details),
                Question(question: "How do growth mindset people view failure?", options: ["As proof of inadequacy", "As valuable feedback", "As permanent", "As something to avoid"], correctAnswerIndex: 1, type: .details),
                Question(question: "What should parents praise to foster a growth mindset?", options: ["Natural intelligence", "Talent only", "Effort and strategies", "Final outcomes only"], correctAnswerIndex: 2, type: .inference),
                Question(question: "Can mindsets be changed?", options: ["No, they are permanent", "Yes, with recognition and practice", "Only in children", "Only with medication"], correctAnswerIndex: 1, type: .details)
            ]
        ),

        // Literature (2 texts)
        TextContent(
            id: "lit_001",
            title: "The Hero's Journey in Storytelling",
            category: .literature,
            difficulty: .intermediate,
            wordCount: 380,
            content: """
Joseph Campbell's concept of the "Hero's Journey" or "monomyth" has become one of the most influential frameworks for understanding storytelling across cultures. Campbell identified a common pattern that appears in myths, legends, and stories from around the world, suggesting a universal structure to how humans tell meaningful tales.

The journey begins with the hero in their ordinary world, living a normal life. Then comes the call to adventure – something disrupts the status quo and invites the hero into the unknown. Many heroes initially refuse this call, held back by fear or obligation. However, a mentor figure often appears to encourage the hero to accept the challenge.

Crossing the threshold into the special world, the hero faces tests, allies, and enemies. This is where character development happens through challenges and growth. The hero approaches the inmost cave – the most dangerous place where their greatest fear lies. Here they face their ordeal, a crisis that requires them to risk everything.

If successful, the hero seizes the reward – whether it's a physical object, knowledge, or reconciliation with their past. But the journey isn't over. The road back often proves as challenging as the way in. The hero returns to the ordinary world transformed, bringing the reward back to benefit others. This return with the elixir completes the cycle.

This pattern appears in countless stories, from ancient myths like Odysseus's journey home to modern films like Star Wars and Harry Potter. Understanding this structure helps us recognize why certain stories resonate so deeply – they tap into archetypes and patterns embedded in human psychology. While not every story follows this exact path, the Hero's Journey provides a powerful lens for understanding narrative structure and meaning.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "Who developed the Hero's Journey concept?", options: ["J.R.R. Tolkien", "Joseph Campbell", "Homer", "George Lucas"], correctAnswerIndex: 1, type: .details),
                Question(question: "What is another name for the Hero's Journey?", options: ["The Adventure", "Monomyth", "The Quest", "Universal Story"], correctAnswerIndex: 1, type: .vocabulary),
                Question(question: "What happens at the 'call to adventure'?", options: ["The hero wins", "The hero returns home", "Something disrupts the ordinary world", "The hero meets enemies"], correctAnswerIndex: 2, type: .details),
                Question(question: "What does the hero bring back to the ordinary world?", options: ["Nothing changes", "The elixir/reward", "More problems", "A mentor"], correctAnswerIndex: 1, type: .details),
                Question(question: "Why does this pattern appear across cultures?", options: ["It's legally required", "It taps into universal human archetypes", "It's the easiest to write", "It's randomly popular"], correctAnswerIndex: 1, type: .inference)
            ]
        ),

        TextContent(
            id: "lit_002",
            title: "The Art of Poetry",
            category: .literature,
            difficulty: .beginner,
            wordCount: 350,
            content: """
Poetry is one of humanity's oldest forms of artistic expression, dating back thousands of years. Unlike prose, which follows ordinary grammatical structure, poetry uses language in concentrated, imaginative ways to evoke emotions, create images, and convey meaning beyond literal words.

Sound plays a crucial role in poetry. Rhyme, rhythm, and meter create musical qualities that make poems memorable and pleasurable to read aloud. Traditional forms like sonnets and haikus follow strict structural rules, while free verse offers poets more flexibility in how they arrange words on the page. Poets carefully choose words not just for meaning but for their sound and how they interact with surrounding words.

Figurative language is poetry's most powerful tool. Metaphors and similes create unexpected connections between unlike things, helping us see the world in new ways. When Robert Burns writes "My love is like a red, red rose," he's not describing his beloved's appearance but capturing something about the nature of his feelings. Personification gives human qualities to non-human things, while imagery appeals to our senses, painting pictures with words.

Poetry can serve many purposes. Some poems tell stories, others capture a single moment or feeling. Political poetry addresses social issues and calls for change. Love poetry explores the complexities of human relationships. Regardless of purpose, good poetry makes us pause and consider language itself, not just what it's describing.

Reading poetry requires patience and openness. Unlike news articles or textbooks that aim for clarity and directness, poems often embrace ambiguity and multiple meanings. A single poem might be interpreted differently by different readers, and that's part of its richness. The best way to appreciate poetry is to read it slowly, perhaps aloud, letting the sounds and images work their magic.
""",
            sourceAttribution: nil,
            questions: [
                Question(question: "What makes poetry different from prose?", options: ["It's always longer", "It uses language in concentrated, imaginative ways", "It has no structure", "It's easier to write"], correctAnswerIndex: 1, type: .details),
                Question(question: "What is free verse?", options: ["Poetry that costs nothing", "Poetry without strict structural rules", "Ancient poetry", "Poetry about freedom"], correctAnswerIndex: 1, type: .vocabulary),
                Question(question: "What figurative device compares two things using 'like' or 'as'?", options: ["Metaphor", "Personification", "Simile", "Imagery"], correctAnswerIndex: 2, type: .vocabulary),
                Question(question: "How should poetry be read according to the text?", options: ["As fast as possible", "Slowly and perhaps aloud", "Only silently", "While multitasking"], correctAnswerIndex: 1, type: .details),
                Question(question: "What does the text say about poetry interpretation?", options: ["There's only one correct meaning", "Different readers may interpret it differently", "Only experts can understand it", "It has no meaning"], correctAnswerIndex: 1, type: .inference)
            ]
        )
    ]
}
